<!--
Example output of the youtube-to-obsidian-notes skill: one sub-note from chapter 1 of
"The Engineering Behind LLM Inference" playlist. Screenshots are replaced with placeholders here;
in the vault they are real images from the video. Open this file in Obsidian to see the callouts.
-->

---
tags: [ai, inference, playlist/llm-inference-first-principles, ch1-memory-wall, prefill, decode]
aliases: [Prefill vs Decode, Same Bytes Different Work, Why decode is slow]
type: video-notes
status: current
date: 2026-11-15
chapter: 1
part: 5
source: "https://www.youtube.com/watch?v=ENkuf_2zbkc&t=629s"
---

# 1.5 Prefill vs Decode — Same Bytes, Different Work

> [!summary] Main learning
> Prefill and decode move the **same bytes** (the full model) on each forward pass. Prefill uses those bytes for **~2,000 tokens** at once. Decode uses them for **1 token**. So prefill is **compute-bound** and decode is **memory-bound**. Decode is not slow because the model is big — it is slow because it has **no tokens to share the cost** of moving the model.

[▶ Watch 10:29](https://www.youtube.com/watch?v=ENkuf_2zbkc&t=629s) · Chapter: [[01 The Memory Wall]] · Previous: [[1.4 Transformer Forward Pass and Weights]] · Next: [[1.6 Arithmetic Intensity and the Roofline Model]]

---

## Two phases, opposite profiles

> 🖼️ *Screenshot `llm-inf-ch1-0640.png` — the video's diagram at this point is embedded here in the vault.*
*▶ [10:40](https://www.youtube.com/watch?v=ENkuf_2zbkc&t=640s)*

Every forward pass drags all the weights across the memory bus. **Not every forward pass does the same amount of work with them.**

When you send a prompt to a language model, the system processes that request in **two phases**. They run on the same chip, use the same model, and share the same forward pass code, but they have **completely opposite resource profiles**.

==🔵 Meaning: Each request has two phases. They look the same from outside (same chip, same model, same code), but inside they use the hardware in opposite ways.==

## Phase 1: Prefill

> 🖼️ *Screenshot `llm-inf-ch1-0670.png` — the video's diagram at this point is embedded here in the vault.*
*▶ [11:10](https://www.youtube.com/watch?v=ENkuf_2zbkc&t=670s)*

The first phase is called **prefill**. The model takes the **entire prompt at once** and processes every token simultaneously through every transformer layer. Attention runs across all positions in parallel. The feed-forward network transforms each vector independently, and by the time it finishes, the model has a representation for every position and is ready to start generating output.

==🔵 Meaning: Prefill reads your full prompt in one go. All prompt tokens go through the model at the same time. At the end, the model understands the prompt and is ready to write the answer.==

## Phase 2: Decode

> 🖼️ *Screenshot `llm-inf-ch1-0690.png` — the video's diagram at this point is embedded here in the vault.*
*▶ [11:30](https://www.youtube.com/watch?v=ENkuf_2zbkc&t=690s)*

The second phase is called **decode**, and this is where the economics of inference change completely. Decode produces output tokens **one at a time**.

To generate the first output token, the model runs a full forward pass and samples from the resulting distribution. To generate the second, it runs another complete forward pass. The third token requires a third pass, the fourth a fourth, and so on, until the model emits a stop signal or hits a length limit.

**Every single output token pays for its own full trip through the entire model.**

==🔵 Meaning: Decode writes the answer one token at a time. Each new token needs one full forward pass through the full model. A 500-token answer = 500 full passes.==

## Apply the rule: arithmetic is cheap, data is expensive

> 🖼️ *Screenshot `llm-inf-ch1-0715.png` — the video's diagram at this point is embedded here in the vault.*
*▶ [11:55](https://www.youtube.com/watch?v=ENkuf_2zbkc&t=715s)*

> 🖼️ *Screenshot `llm-inf-ch1-0750.png` — the video's diagram at this point is embedded here in the vault.*
*▶ [12:30](https://www.youtube.com/watch?v=ENkuf_2zbkc&t=750s)*

Now we can look at these two phases through the asymmetry we established earlier.

**In prefill**, the model loads each layer's weights from HBM into the arithmetic units **once**, and that single weight transfer gets used for arithmetic on **every token in the prompt simultaneously**. For a 2,000-token prompt, every byte pulled from memory gets used in roughly **2,000 multiply-accumulate operations** before the chip is done with it.

==🔵 Meaning: In prefill, the chip loads the weights one time and uses them for all 2,000 prompt tokens. Each byte does about 2,000 units of math. Many tokens share the data cost.==

**In decode**, the model loads the exact same weights, moves the exact same number of bytes. But all of that data movement serves **a single token** of output. One token generated, one full weight transfer paid. When serving a single request, the ratio of useful arithmetic to bytes moved drops from around **2,000 to roughly one**.

==🔵 Meaning: In decode, the chip moves the same 140 GB, but uses it for only one token. Each byte does about 1 unit of math. The full data cost goes to one token.==

| | Prefill | Decode |
|---|---|---|
| Tokens per forward pass | All prompt tokens (e.g. 2,000) | 1 |
| Bytes moved per pass | Full model | Full model (same!) |
| Math per byte | ~2,000 | ~1 |
| Bottleneck | Compute | Memory bandwidth |

## The structural fact

> 🖼️ *Screenshot `llm-inf-ch1-0790.png` — the video's diagram at this point is embedded here in the vault.*
*▶ [13:10](https://www.youtube.com/watch?v=ENkuf_2zbkc&t=790s)*

This is the structural fact that I think **defines LLM inference**. From the outside, prefill and decode look like the same workload: same model, same chip, same code. But prefill gets **thousands** of arithmetic operations out of every byte it moves from memory, and decode gets **one**.

The memory bus pays **the same toll** in both phases. The payoff from that toll differs by **a factor of thousands**.

==🔵 Meaning: Both phases pay the same price to move the model. Prefill gets thousands of times more useful work from that price than decode.==

## The common wrong guess

> 🖼️ *Screenshot `llm-inf-ch1-0805.png` — the video's diagram at this point is embedded here in the vault.*
*▶ [13:25](https://www.youtube.com/watch?v=ENkuf_2zbkc&t=805s)*

> 🖼️ *Screenshot `llm-inf-ch1-0825.png` — the video's diagram at this point is embedded here in the vault.*
*▶ [13:45](https://www.youtube.com/watch?v=ENkuf_2zbkc&t=825s)*

A natural first guess is that decode is slow because the model is large, and that guess is correct in a way that misses the deeper point. The model is **exactly the same size** in both phases, and the bytes transferred per forward pass are **exactly the same**. What changes is **how much useful computation those transferred bytes actually perform**.

==🔵 Meaning: The same data moved across the bus does more or less work, depending on the phase.==

Prefill **amortizes** (spreads out) the cost of moving the model across the bus over thousands of tokens of parallel work.

==🔵 Meaning: The weights are loaded once, then used for thousands of tokens at the same time. Many tokens split the loading cost, so each one costs little.==

Decode has **no tokens to share the cost with**.

==🔵 Meaning: The weights are loaded for just one token, then the math finishes quickly. Decode has only one token to pay for the loading, so the GPU spends most of its time waiting for data.==

Next, we put real numbers on this and place both phases on a standard performance diagram (→ [[1.6 Arithmetic Intensity and the Roofline Model]]).

---

> [!important] Key learnings
> - Prefill = **whole prompt in parallel**, one pass. Decode = **one token per full pass**.
> - Both phases move the **same bytes** (the full model) on each pass.
> - Prefill: each byte → **~2,000** operations. Decode: each byte → **~1** operation.
> - ⭐ Decode is slow **not because the model is big**, but because **one token pays the full cost** of moving the model.
> - Prefill = compute-bound. Decode = memory-bound. See also [[Prefill and Decode]].

## Self-test

> [!question]- Do prefill and decode move a different amount of data per forward pass?
> No. Both move the full model weights. The difference is how many tokens use that data.

> [!question]- For a 2,000-token prompt, how many operations does each byte do in prefill vs decode?
> Prefill: about 2,000. Decode (batch size 1): about 1.

> [!question]- "Decode is slow because the model is big." Why is this only half true?
> The model is the same size in prefill, and prefill is fast per token. Decode is slow because each full weight transfer serves only one token — there is no other token to share the cost.

> [!question]- What does "amortize" mean here?
> Spread the cost of moving the model across many tokens, so each token pays only a small part.
