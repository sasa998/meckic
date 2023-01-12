FROM node:16-alpine AS builder
ARG environment
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY . .
ENV NEXT_TELEMETRY_DISABLED 1
RUN yarn install && yarn build:$environment
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/* ./
USER nextjs
EXPOSE 8000
CMD ["next", "start"]