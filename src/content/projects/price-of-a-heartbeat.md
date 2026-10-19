---
title: 'The Price of a Heartbeat'
summary: 'What US insurers pay hospitals for cardiac rehab and stress testing, and what more patients and more sessions are worth to a program.'
detail: 'Hospitals now publish their negotiated rates. I matched those contracts across more than 1,700 US hospital price files to CDC Medicare data on who starts and finishes cardiac rehab. Commercial plans pay Washington hospitals the second-highest rate in the country, yet Washington enrolls and retains fewer patients than most of the US. The dashboard turns that gap into dollars for any state, and forecasts a program from its own monthly numbers.'
status: 'live'
statusLabel: 'Beta dashboard live'
order: 2
stack: 'Python · DuckDB · SQL · JavaScript'
data: 'Hospital price transparency files (July 2026), CDC Atlas of Heart Disease and Stroke (Medicare, 2019–2020), CMS OPPS 2026'
scope: 'United States, with Washington hospital detail · cardiac rehab and stress testing'
period: '2026'
repo: 'https://github.com/bentileo/price-of-a-heartbeat'
demo: '/projects/price-of-a-heartbeat/dashboard/'
---

## Why this project

The ECG toolkit answers a clinical question with a model. This project is the
other half of the work: taking messy public datasets, joining them, and
answering a question a health system executive actually asks on a Monday morning.

I have spent four years inside a cardiac service line. The questions asked in
that room are financial as often as they are clinical. Which payers reimburse
well for the services we run? Are our contracts below what comparable hospitals
negotiated? Where is the gap between the care we deliver and the revenue it
produces?

I narrowed the work to the services a clinical exercise physiologist runs every
day: cardiac rehab sessions and exercise, echo and nuclear stress testing.

## What the dashboard shows

<div class="note"><strong>In Washington, the revenue gap is volume, not price.</strong>
Commercial plans pay Washington hospitals well. Too few eligible patients start
cardiac rehab, and too few finish it.</div>

- **Price.** Commercial plans pay Washington hospitals a typical **$363** for a
  monitored cardiac rehab session, second among states with enough price files
  to compare (Oregon is first at $382). The typical US commercial rate is $166.
  Medicare and Medicare Advantage pay about $132.
- **Enrollment.** In Washington's typical county, 32% of eligible Medicare
  patients start cardiac rehab, against 36% nationally.
- **Retention.** 26% of Washington starters finish all 36 sessions, against 33%
  nationally. The average starter attends 23.5.
- **What it is worth.** For every 100 eligible patients, a Washington program
  brings in roughly $150,000 a year at a typical payer mix. Matching a
  top-quarter US county on enrollment and attendance adds roughly $105,000.

The dashboard has three parts: a US map that compares states on price,
enrollment, completion and unbilled sessions; a Washington view that places one
hospital's contracts against its peers, insurer by insurer; and a program model
that prices referral, enrollment and attendance improvements, or forecasts a
program from its own monthly numbers.

## How it works

<div class="flow">
<b>Hospital price files</b> — 1,700+ US hospitals, billions of rows<br>↓<br>
<b>Keep commercial fee-schedule contracts</b> — plan names classified, physician fees and unit errors dropped<br>↓<br>
<b>Match facilities to CMS</b> — 94 Washington facilities reviewed by hand; ERs and clinics rejected<br>↓<br>
<b>Benchmark</b> — insurer × service × hospital type, each price file counted once<br>↓<br>
<b>Join CDC Medicare data</b> — who starts, who finishes, sessions attended, by county<br>↓<br>
<b>Dashboard and program model</b>
</div>

Price files carry no certification number, so every Washington facility was
matched to its CMS record by name and address and checked by hand. Twenty of 94
were rejected: freestanding emergency rooms, clinics, a psychiatric hospital,
and two locations that one rural district's file lists by mistake.

## What changed from the plan

The original plan multiplied rates by CMS outpatient volumes. That file is now
published by payment group rather than procedure code, and it leaves cardiac
rehab out entirely, so per-hospital volumes are not available for free. The
dashboard measures volume a different way, per 100 eligible patients from CDC
data, and lets a program bring its own monthly numbers for a forecast.

## What the data cannot support

- A published rate is a contract term, not proof of what was paid or that the
  service is offered.
- Rates are self-published and hospitals interpret the schema differently. Some
  states' rates are implausibly low, which points at filing practice rather
  than payment.
- The CDC publishes county figures only, so state values are the typical
  county, not a patient-weighted average. They cover Medicare fee-for-service
  patients in 2019–2020.
- This estimates revenue. It does not estimate cost, so it cannot speak to
  margin.

## Status

Beta. Next: a second price snapshot to start a price time series, pulmonary
rehab, and splitting results by hospital system.

*I work at UW Medicine. Every input is public data, and UW Medicine facilities
are not excluded.*
