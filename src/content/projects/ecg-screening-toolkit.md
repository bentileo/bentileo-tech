---
title: 'ECG Screening Toolkit'
summary: "A machine learning system that reads an ECG and flags what warrants a clinician's attention. Version one detects atrial fibrillation; the roadmap extends to ischemic ST changes, conduction abnormalities, and ECGs captured as photographs."
detail: "A machine learning system that reads an ECG and flags what warrants a clinician's attention. Version one detects atrial fibrillation from rhythm irregularity, built end to end from raw PhysioNet waveforms to a deployed application. The roadmap extends to ischemic ST changes, conduction abnormalities, and ECGs captured as photographs rather than digital signals."
status: 'live'
statusLabel: 'v1 live at ecg.bentileo.tech'
order: 1
stack: 'Python · scikit-learn · Streamlit · Supabase · nginx'
data: 'PTB-XL — 21,799 clinical ECGs, 18,869 patients'
period: '2026'
repo: 'https://github.com/bentileo/ecg-afib'
demo: 'https://ecg.bentileo.tech'
---

## The problem

Atrial fibrillation is common, often silent, and carries a stroke risk that
anticoagulation can substantially reduce. The diagnosis hinges on a pattern that
is visually obvious once you know it: the intervals between beats become
irregularly irregular, with no underlying periodicity at all.

<figure>
<svg viewBox="0 0 700 150" preserveAspectRatio="none">
<path d="M0,55 L40,55 L46,50 L52,55 L70,55 L74,60 L78,20 L82,68 L86,55 L110,55 L118,46 L126,55 L160,55 L166,50 L172,55 L190,55 L194,60 L198,20 L202,68 L206,55 L230,55 L238,46 L246,55 L280,55 L286,50 L292,55 L310,55 L314,60 L318,20 L322,68 L326,55 L350,55 L358,46 L366,55 L400,55 L406,50 L412,55 L430,55 L434,60 L438,20 L442,68 L446,55 L470,55 L478,46 L486,55 L520,55 L526,50 L532,55 L550,55 L554,60 L558,20 L562,68 L566,55 L590,55 L598,46 L606,55 L640,55 L646,50 L652,55 L670,55 L674,60 L678,20 L682,68 L686,55 L700,55" fill="none" stroke="#16161A" stroke-width="1.3"/>
<path d="M0,130 L30,130 L34,126 L38,130 L48,130 L51,134 L54,100 L57,142 L60,130 L80,130 L86,122 L92,130 L106,130 L109,134 L112,100 L115,142 L118,130 L150,130 L153,134 L156,100 L159,142 L162,130 L185,130 L191,122 L197,130 L240,130 L243,134 L246,100 L249,142 L252,130 L268,130 L271,134 L274,100 L277,142 L280,130 L330,130 L333,134 L336,100 L339,142 L342,130 L360,130 L363,134 L366,100 L369,142 L372,130 L430,130 L433,134 L436,100 L439,142 L442,130 L455,130 L458,134 L461,100 L464,142 L467,130 L530,130 L533,134 L536,100 L539,142 L542,130 L560,130 L563,134 L566,100 L569,142 L572,130 L620,130 L623,134 L626,100 L629,142 L632,130 L660,130 L663,134 L666,100 L669,142 L672,130 L700,130" fill="none" stroke="#C8342B" stroke-width="1.3"/>
<text x="8" y="16" font-family="Inter" font-size="10" fill="#5C5C64" letter-spacing="1">SINUS RHYTHM — evenly spaced</text>
<text x="8" y="92" font-family="Inter" font-size="10" fill="#C8342B" letter-spacing="1">ATRIAL FIBRILLATION — irregularly irregular</text>
</svg>
<figcaption>The signal the model learns. Both strips are ten seconds of lead II.</figcaption>
</figure>

## Decisions, and why

### The target changed once the features were measured

The original goal was normal-versus-abnormal classification. Measurement showed
that was not supportable. The features here derive from R-peak positions, which
describe rate and rhythm. But "abnormal" in this dataset is dominated by
myocardial infarction, hypertrophy, and ischemia — conditions whose signatures
live in wave morphology. A patient with an old anterior infarct sits at 72 beats
per minute, perfectly regular, with a pathological Q wave that no interval
measurement can see.

Tested against that target, the rhythm features did not separate the classes at
all: median RR variability was 0.028 in both groups. Against atrial fibrillation
they separate sharply — 0.197 against 0.026, with the 25th percentile of the
AFib group sitting above the 75th percentile of everything else.

### Wave delineation was measured and rejected

PR, QRS, and QT features were attempted first. Against a recording with a
directly verified 94 ms QRS, the delineator returned per-beat values from 78 to
208 ms across a single regular rhythm. That is not physiological variation; it is
boundary detection failing.

<div class="note"><strong>Why bounds could not rescue it.</strong> A 168 ms QRS
is anatomically possible in bundle branch block, so no sanity check rejects it —
even when the true value is 94 ms. Bounds catch the impossible, not the merely
wrong.</div>

### Splitting by patient, not by recording

Several patients contribute more than one recording. A random split would place
one patient's recordings on both sides of the train and test boundary, letting
the model score well by recognizing the person rather than the pathology. Every
fold is grouped by patient identifier and verified to share zero patients across
train and test.

### The labels were verified against the source

An apparent contradiction appeared early: 37 recordings carried both a "normal"
and an "atrial fibrillation" code. Reading the cardiologists' free-text reports
resolved it. Those records say things like *"atrial fibrillation. otherwise no
definite pathology."* The normal code means *otherwise* normal.

### Excluded recordings are label-biased, and this is stated

223 recordings, about 1%, were removed because R-peak detection failed. Those
exclusions are not random: 15% of them are atrial fibrillation against a 6.9%
baseline, because fibrillatory baselines are genuinely harder to delineate than
clean regular rhythms. Removing them deletes some of the hardest positives and
makes the reported metrics modestly optimistic.

## Results

Patient-grouped, label-stratified five-fold cross-validation across 21,576
recordings. Accuracy is not reported: with 6.9% positives, a model that never
predicts atrial fibrillation is 93% accurate and clinically useless.

| Threshold | Recall | Precision |
| --- | --- | --- |
| 0.10 — operating point | 0.96 | 0.34 |
| 0.20 | 0.92 | 0.41 |
| 0.30 | 0.87 | 0.46 |
| 0.50 — default | 0.74 | 0.58 |

### The operating threshold is a clinical decision

The threshold sits at 0.10 rather than the conventional 0.50, because the two
errors are not equally costly. A missed case leaves a patient at unmonitored
stroke risk. A false positive costs a confirmatory review.

Maximizing recall is defensible only because flagged recordings receive human
confirmation. A fully autonomous system would need a higher-precision operating
point, because a tool that cries wolf gets ignored, and alert fatigue costs
sensitivity in practice that no confusion matrix records.

## Limitations

- Version one detects rhythm irregularity, so it cannot separate atrial
  fibrillation from flutter, frequent ectopy, or sinus arrhythmia. That needs
  P-wave and QRS morphology, and it bounds precision by design.
- Ten-second recordings are shorter than the rhythm strip a clinician would use.
- Not clinically validated. Not a medical device.

## Architecture

<div class="flow">
<b>PTB-XL waveforms</b><br>↓<br>
<b>R-peak detection</b><br>↓<br>
<b>RR-interval features</b><br>↓<br>
<b>Signal-quality filtering</b><br>↓<br>
<b>Patient-grouped cross-validation</b><br>↓<br>
<b>Random forest</b><br>↓<br>
<b>Streamlit dashboard on a VPS</b>
</div>

## Roadmap

**Image digitization.** Accept a photograph of a paper ECG, recover the
underlying signal, and classify it. This is the version usable outside a research
dataset.

**Morphology features.** Revisit delineation with a delineator validated against
annotated boundaries, using the dataset's own bundle branch block and AV block
labels as ground truth. This is what extends the toolkit beyond rhythm to
ischemic ST changes and conduction disease.

**Explainability.** Surface which features drove a prediction, so a clinician
sees why a recording was flagged rather than trusting a probability.

## What running this publicly required

A model in a notebook has no attack surface. One accepting uploads on the open
internet does, and closing it took as much thought as the model.

Screening results are stored in Supabase, which means a credential ships inside
the application and must be assumed public. So the database uses two keys rather
than one: a publishable key with permission to insert a result and nothing else,
and a secret key that reads them back. Streamlit renders on the server rather
than in the browser, so the second key never reaches a client. The history view
is additionally gated behind a password, and the database refuses reads from the
public key even if the interface were bypassed.

Uploads are bounded before any processing — file size, sample count, numeric
content, and amplitude, each rejected with a message a person can act on rather
than a stack trace. Inserts are rate limited, and a check constraint rejects
values the model could not have produced.

The waveform itself is never stored. It exists in memory for one screening and
is discarded; only the outcome is recorded. The repository's
[SECURITY.md](https://github.com/bentileo/ecg-afib/blob/main/SECURITY.md) states
what this protects and, more usefully, what it does not.
