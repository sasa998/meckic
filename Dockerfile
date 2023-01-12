#phase 1- Dependancy
FROM node:16-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app
ARG environment
# Install dependencies based on the preferred package manager
COPY package.json yarn.lock* ./
ENV NEXT_TELEMETRY_DISABLED 1
RUN yarn install

# Rebuild the source code only when needed
FROM node:16-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN yarn build:$environment

# Production image, copy all the files and run next
FROM node:16-alpine AS runner
WORKDIR /app

ENV NODE_ENV $environment
ENV NEXT_TELEMETRY_DISABLED 1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/* ./
USER nextjs
EXPOSE 8000

CMD ["next", "start"]