# Case Study: Customer & Competitive Intelligence for Amazon Reviews (V1)

**A proof-of-concept AI system that turns raw product reviews into competitive intelligence — built end-to-end, from data pipeline to executive report.**

[**→ View the live dashboard**](https://public.tableau.com/app/profile/fkeilers/viz/Customer_Competitive_Intelligence_Amazon_Reviews_V1/00_Dashboard_Customer_Competitive_Intelligence_Amazon_Reviews_V1)

---

## The business question

If you sold headphones on Amazon, how would you know — with statistical confidence, not gut feeling — where you actually win and lose against your competitors?

This project answers that question for a real market segment: premium active-noise-cancelling (ANC) headphones. Sennheiser was treated as the anchor brand (the hypothetical "client"), benchmarked against Bose, Sony, Bang & Olufsen, and Bowers & Wilkins, using 2,302 real Amazon reviews.

The goal was never generic "sentiment analysis." It was a specific, decision-oriented question: *what do customers value, what do they criticize, and how does one brand's premium line compare to its direct competitors — with enough rigor that the answer would hold up to scrutiny from someone whose job is to be skeptical of it.*

## Approach, at a glance

The system follows CRISP-DM (the standard industry framework for data mining projects) end to end, on top of a Medallion (bronze/silver/gold) data architecture:

1. **Data collection** — real reviews sourced from the McAuley Lab Amazon Reviews 2023 dataset (UC San Diego), filtered by product line and price floor to isolate the premium ANC segment specifically, not every headphone a brand has ever sold.
2. **Ground truth** — 200 reviews (40 per brand) hand-labeled across 7 product aspects, used to validate the AI's accuracy before trusting its output on the full dataset.
3. **Model bake-off** — two LLMs (Llama 3.3 70B and GPT-OSS 120B) evaluated against a 9-metric protocol defined *before* seeing either model's results, specifically to avoid the trap of picking whichever metric happens to favor a preferred outcome. Both models passed the required quality bar; the tie was broken on measured speed, reliability, and classification balance — not on assumptions.
4. **Competitive analysis** — the full 2,302-review dataset scored across 7 aspects (sound quality, noise cancelling, battery, comfort, design, software/connectivity, value), with statistical significance testing applied to any finding presented as a firm conclusion.
5. **Reporting** — an executive report and a public dashboard, built for a decision-maker, not a data scientist.

## What the analysis actually found

A few honest highlights — not the full report, but enough to show the kind of thinking behind it:

- **The initial hypothesis about design positioning was wrong, and the data said so.** The working assumption was that Sennheiser ceded "design/status" territory to Bang & Olufsen and Bowers & Wilkins. The reviews showed the opposite: Sennheiser had the *highest* rate of design/comfort mentions of all five brands.
- **"Sennheiser sounds better" didn't survive a proper significance test.** An early read of the data suggested a sound-quality edge for Sennheiser. Once tested with bootstrap confidence intervals — the same standard applied to every other claim in the report — that edge disappeared. All five brands are statistically tied on sound quality. Reporting the *correction*, not just the initial (wrong) read, was a deliberate choice.
- **Two consistent, real weaknesses did hold up under testing:** battery life and noise cancelling, both ranked last of five brands, with the ANC gap being statistically significant specifically against the two ANC leaders in this sample.
- **A keyword-based safety alert detector, calibrated against real data, surfaced 3 isolated cases worth a closer look** out of 2,302 reviews — findings that don't move any statistical average, but that a careful audit process is designed to catch anyway. See the dashboard's Priority Alert panel for detail; brand identities are withheld there, since a single uncorroborated review isn't a verified claim against any specific company.

## What this project is honest about

This is the part most portfolio pieces skip, and it's arguably the most important part of this one:

- **The sample size for four of five brands is a sample of unknown population size**, not a census — treated with confidence intervals throughout, never presented as more certain than it is.
- **The ground truth was labeled by a single annotator** (the project's author). That's an accepted limitation for an academic deliverable; it would not be an accepted standard for a paid commercial engagement without inter-annotator agreement testing.
- **The safety alert detector is keyword-based**, which means it has a measurable false-positive rate (caught and corrected during calibration) but an *unmeasurable* false-negative rate — a real review describing a real hazard, worded outside the keyword list, would simply not be flagged. This is a known, documented limitation, not a hidden one — and it's the first item on the V2 roadmap below.

## Why the full pipeline isn't in this repository

This repository intentionally includes only the data exploration and collection stage (notebooks `00`–`01`) plus the SQL scripts. The reusable engine — the multi-provider AI pipeline, the model validation protocol, the statistical analysis, and the dashboard-prep logic — lives in a private repository.

That's not an oversight. The engine is largely category-agnostic: point it at a different product vertical, adjust the prompt schema, and the same validation rigor applies. That reusability is the actual asset here, and publishing it in full would give away the thing this project is meant to demonstrate the *value* of, not the thing itself. See the main README for more on this reasoning.

## What's next

This is treated as a living system, not a closed deliverable — see the **Roadmap** section in the main README for what's already planned for V2.

---

*This project is not affiliated with, endorsed by, or sponsored by Amazon.com, Inc. Dataset: Amazon Reviews 2023 (McAuley Lab, UC San Diego), used under CC BY-SA 4.0 license.*
