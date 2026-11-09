---
title: 'Cardiac Clinic Benchmark & Revenue Forecasting'
kicker: 'Health economics · Forecasting'
summary: 'What commercial insurers pay US hospitals for cardiac rehab, stress testing and echocardiography, state by state against Medicare, and what a clinic can forecast from it.'
detail: 'Hospitals now publish the rates they negotiate with every insurer. I processed the files of 2,700 US hospitals for nine cardiac codes, cleaned them against the published literature, and built a dashboard that benchmarks every state against Medicare, shows whether expensive states are expensive across the board, and lets a clinic compare its own contract and monthly volumes to its state and project the next twelve months.'
status: 'live'
statusLabel: 'Beta dashboard live'
order: 1
stack: 'Python · DuckDB · SQL · JavaScript (SVG)'
data: 'Hospital price-transparency files, 2,700+ hospitals, July 2026 snapshot · CMS OPPS 2026 · CDC Atlas of Heart Disease and Stroke'
scope: 'United States, 50 states · cardiac rehab, exercise stress test, stress echo, nuclear stress (single and complete), resting echo'
period: '2026'
repo: 'https://github.com/bentileo/price-of-a-heartbeat'
demo: '/projects/price-of-a-heartbeat/dashboard/'
---

## The question

A cardiac service line lives on a handful of procedure codes: a rehab session,
a treadmill test, a stress echo, a nuclear perfusion study, a resting
echocardiogram. Medicare pays one national rate for each. Commercial insurers
pay whatever the hospital negotiated, and until 2021 nobody outside that
negotiation knew what that was. Since the Hospital Price Transparency Rule,
every hospital publishes it.

So: what do commercial insurers actually pay for these services, how does it
vary by state, and what can a clinic do with that number?

## What the dashboard shows

**Benchmark.** One tab per CPT code. A US map colors every state by its typical
commercial rate (quintiles), with Medicare's rate as the reference. Click a
state for its price, rank of 50, cash price, how many hospital files sit behind
the figure, and where it falls on the national range.

**Compare.** A ranked bar chart of all 50 states against the Medicare line; a
heatmap of every state's price-to-Medicare ratio across all services with a
rank-correlation matrix answering whether a state that pays well for one
cardiac service pays well for all (it does: the weakest pair of services still
correlates above 0.5); and, for cardiac rehab, a quintile chart showing that the
states paid the most enroll no more eligible patients than the states paid the
least.

**Your clinic.** Pick a state and get the descriptive statistics: lowest,
quartiles, median, highest, where the state ranks. Enter your own contracted
rate, monthly volume and Medicare share to see your annual revenue beside the
same volume at the state's typical rate and at Medicare. Load your monthly
history and the page fits a trend-plus-seasonality model, checks it on six
held-out months, and projects twelve months with an 80% range. Your numbers
never leave the browser.

## Headline numbers (US, median hospital, July 2026)

| Service | CPT | Commercial | Medicare 2026 | Ratio |
|---|---|---|---|---|
| Cardiac rehab session | 93798 | $224 | $132 | 1.7× |
| Exercise stress test | 93017 | $665 | $221 | 3.0× |
| Stress echo, complete | 93351 | $1,235 | $558 | 2.2× |
| Nuclear stress, single study | 78451 | $2,219 | $1,323 | 1.7× |
| Nuclear stress, complete | 78452 | $2,830 | $1,323 | 2.1× |
| Resting echo with Doppler | 93306 | $1,392 | $558 | 2.5× |

One result surprises clinicians: hospitals price a stress echo and a resting
echo almost identically, and the resting study is often higher. That is not a
data error. Medicare pays all three echo codes the same APC rate, and
commercial facility contracts follow the same grouping; the difference
clinicians feel is in the professional fee and the separately billed stress
test. Two independent studies of the same files (JASE 2023, JAHA 2025) report
the same ordering.

## Getting the data right

The files are messy, and most of the work was deciding what a real negotiated
facility rate looks like. The rules, applied identically to every state and
code:

- Use every contract row that publishes a dollar amount. Fee-schedule rows
  alone miss percent-of-charge contracts, the largest group, which price about
  twice as high; using only fee schedules biased every service low by a third.
- Classify each contract from its payer and plan names and keep commercial
  only; Medicare Advantage, Medicaid and government contracts out.
- Drop rates under 50% of Medicare (physician fees published inside facility
  files), rates at or above the hospital's own gross charge (list prices
  pasted into the negotiated column), rates above six times Medicare when no
  gross charge is published, and any hospital file that prices a lesser study
  above the complete one.
- One median per hospital file, then the median of files per state; a state
  needs three clean files or it takes its census-division median and is
  labeled estimated.

After cleaning, the national medians match the published literature within a
few percent, which is the check I trust most.

## What the data cannot say

A published rate is a contract term, not a paid claim; denials and patient
cost-sharing are invisible. The lake is a single snapshot, so there is no
price trend yet. No public source reports stress-test volumes or cardiac rehab
referrals, so the forecast runs on a clinic's own history. The CDC enrollment
and completion figures are Medicare fee-for-service, 2019–2020, and predate
the pandemic.

## Stack

DuckDB over 77 GB of parquet for the extraction (resumable, four minutes a
pass); Python for the cleaning rules and QA report; a single-file dashboard in
hand-written SVG with no charting library, so it loads from a static host and
works offline. The Python package, tests and scripts are in the repository.
