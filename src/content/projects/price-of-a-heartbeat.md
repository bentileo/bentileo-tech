---
title: 'The Price of a Heartbeat'
summary: 'Hospitals now publish what they charge. This project joins those rates to utilization data to estimate what cardiac diagnostics actually earn, and where hospitals negotiated below their peers.'
detail: 'Hospitals must now publish their negotiated rates in a standardized format, but a rate alone cannot answer a revenue question — a high price on a procedure nobody orders is worth nothing. This project joins those rates to CMS utilization data to estimate what cardiac diagnostics actually earn across Washington State, and where hospitals negotiated below what regional peers secured.'
status: 'building'
statusLabel: 'In design'
order: 2
stack: 'Python · SQL · Plotly'
scope: 'Washington State · cardiac diagnostics'
---

## Why this project

The ECG toolkit answers a clinical question with a model. This project is the
other half of the work: taking two messy public datasets, joining them, and
answering a question a health system executive actually asks on a Monday morning.

I have spent four years inside a cardiac service line. The questions asked in
that room are financial as often as they are clinical. Which payers reimburse
well for the tests we run? Are we performing procedures at rates below what
comparable hospitals negotiated? Where is the gap between the care we deliver and
the revenue it produces?

Those questions became answerable in a way they were not three years ago.

## The opening

Since 2021, hospitals have been required to publish their negotiated rates. Since
April 2026, they must do so in a standardized machine-readable format, which for
the first time makes rates comparable across institutions. Most hospitals now
post something; considerably fewer post something usable.

The result is one of the largest pricing datasets in American healthcare, and it
is barely analyzed outside of consultancies. Published analysis has found
negotiated rates for the same inpatient procedure varying by a ratio of roughly
nine to one across the country, and different payers paying materially different
amounts for the same procedure at the same hospital.

## The problem with rates alone

Price transparency files list what a hospital negotiated. They do not list how
often the service was performed. Revenue is rate multiplied by volume, so rates
by themselves cannot answer a revenue question — a high rate on a procedure
nobody orders is worth nothing.

<div class="note"><strong>This is the technical core of the project.</strong>
Rates come from hospital transparency files; volumes come from CMS utilization
data. Joining them means matching hospitals across two systems that identify
facilities differently, and documenting honestly what fails to reconcile.</div>

## Data

| Source | Provides |
| --- | --- |
| Hospital price transparency files | Payer-specific negotiated rates by procedure code, standardized across roughly 5,000 hospitals |
| CMS utilization and payment data | Service volumes and Medicare payment by provider and procedure |
| CMS hospital cost reports (HCRIS) | Facility characteristics, payer mix, and operating margin for context |

## The questions

<p class="q">For a given cardiac diagnostic, how does one hospital's negotiated
rate compare to the rates its regional peers secured from the same payer?</p>

<p class="q">Which payers reimburse cardiac diagnostics well, and which reimburse
poorly relative to the market?</p>

<p class="q">Where volume is high and the negotiated rate sits below the regional
median, how much revenue does that gap represent annually?</p>

<p class="q">Do hospitals with weaker operating margins also negotiate weaker
rates, or is rate negotiation independent of financial health?</p>

## Approach

<div class="flow">
<b>Hospital transparency files</b> &nbsp;+&nbsp; <b>CMS utilization data</b><br>↓<br>
<b>Match facilities</b> — NPI and CCN crosswalk, manual reconciliation<br>↓<br>
<b>Filter to cardiac diagnostic codes</b> — echo, stress testing, catheterization<br>↓<br>
<b>Estimate revenue</b> — rate × volume, by payer and facility<br>↓<br>
<b>Benchmark against regional peers</b><br>↓<br>
<b>Dashboard and written recommendation</b>
</div>

## Scope, deliberately narrow

Washington State, cardiac diagnostics only. The dataset is national and the
temptation is to analyze all of it, but a finished narrow analysis is worth more
than an unfinished broad one — and a local scope means I can sanity-check the
output against hospitals I know. If the model says a facility is underpaid for
stress echocardiography, I can ask whether that is plausible.

## What the data cannot support

- Transparency files cover hospital-based services only. Most healthcare
  encounters happen elsewhere, so this is not a complete picture of a system's
  revenue.
- Rates are self-published and hospitals interpret the schema differently. Data
  quality varies, and some files are compliant in name only.
- Utilization data skews Medicare. Commercial volume must be estimated rather
  than observed, and that assumption needs stating every time a number is quoted.
- This estimates revenue. It does not estimate cost, so it cannot speak to margin.

## Status

In design. Data sources identified and limitations mapped; the facility join is
the next problem to solve.
