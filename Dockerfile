FROM node:16-alpine AS builder
ARG environment
RUN addgroup --system --gid 1001 nodejs && \
     adduser --system --uid 1001 nextjs && \
     apk add --no-cache libc6-compat && \
     mkdir -p /home/nextjs/app && chown -R nextjs:nodejs /home/nextjs/app
WORKDIR /home/nextjs/app
USER nextjs
COPY . .
ENV NEXT_TELEMETRY_DISABLED 1
RUN yarn install && yarn build:$environment
EXPOSE 8000
CMD ["yarn", "start"]