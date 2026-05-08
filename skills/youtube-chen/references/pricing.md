# Token Pricing Reference

## Claude Sonnet 4 (anthropic/claude-sonnet-4-6)
- Input: $3.00 / 1M tokens
- Output: $15.00 / 1M tokens

## Estimation Formula
- Transcript tokens ≈ duration_seconds × 3.25 (150 words/min × 1.3 tokens/word)
- Output doc ≈ 8,000 tokens (50-page technical document)
- Total cost = (input_tokens × 0.000003) + (output_tokens × 0.000015)

## Typical Examples
| Video Length | Est. Input Tokens | Est. Cost |
|---|---|---|
| 10 min | ~1,950 | ~$0.006 |
| 30 min | ~5,850 | ~$0.018 |
| 1 hour | ~11,700 | ~$0.035 |
| 2 hours | ~23,400 | ~$0.07 |

Note: Costs are estimates. Actual cost depends on transcript length and document complexity.
Update pricing if model changes.
