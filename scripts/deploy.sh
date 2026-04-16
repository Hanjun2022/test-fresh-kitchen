#!/bin/bash
set -e

AWS_REGION="${AWS_REGION:-us-east-1}"
ECR_REGISTRY="${ECR_REGISTRY:-339713026502.dkr.ecr.us-east-1.amazonaws.com}"
echo "▶ ECR 로그인"
aws ecr get-login-password --region "$AWS_REGION" \
  | docker login --username AWS --password-stdin "$ECR_REGISTRY"

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "▶ 기존 컨테이너 종료"
docker-compose -f "$DIR/../docker-compose.yml" down || true
docker container prune -f

echo "▶ 새 컨테이너 실행"
docker-compose -f "$DIR/../docker-compose.yml" up -d

echo "✅ 배포 완료"