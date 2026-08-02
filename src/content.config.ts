import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';
import { z } from 'astro/zod';

const projects = defineCollection({
  loader: glob({ base: './src/content/projects', pattern: '**/*.md' }),
  schema: z.object({
    title: z.string(),
    // One-line description used on cards and as the page summary.
    summary: z.string(),
    // Longer description shown on the projects index only.
    detail: z.string().optional(),
    // Drives the status wording on cards and detail pages.
    status: z.enum(['live', 'building', 'planned']),
    statusLabel: z.string(),
    // Lower numbers appear first.
    order: z.number().default(99),
    stack: z.string(),
    data: z.string().optional(),
    scope: z.string().optional(),
    period: z.string().optional(),
    repo: z.string().optional(),
    demo: z.string().optional(),
  }),
});

export const collections = { projects };
