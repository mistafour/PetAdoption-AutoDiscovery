echo "deleting jenkins and vault server"
cd jenkins-vault
terraform init 
terraform destroy -auto-approve

# ── 1. Delete all object versions
echo "Deleting all object versions..."
VERSIONS=$(aws s3api list-object-versions --bucket "pet-adoption-state-bucket-one-pet" --region "eu-west-3" \
  --query 'Versions[].{Key:Key,VersionId:VersionId}' --output json)

if [[ "$VERSIONS" != "null" && "$VERSIONS" != "[]" ]]; then
  echo "$VERSIONS" | jq -c '.[]' | while read -r obj; do
    KEY=$(echo "$obj" | jq -r '.Key')
    VID=$(echo "$obj" | jq -r '.VersionId')
    aws s3api delete-object --bucket "pet-adoption-state-bucket-one-pet" --key "$KEY" --version-id "$VID" --region "eu-west-3" > /dev/null
  done
fi
echo "✔ Object versions deleted"

# ── 2. Delete all delete markers
echo "Deleting all delete markers..."
MARKERS=$(aws s3api list-object-versions --bucket "pet-adoption-state-bucket-one-pet" --region "eu-west-3" \
  --query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}' --output json)

if [[ "$MARKERS" != "null" && "$MARKERS" != "[]" ]]; then
  echo "$MARKERS" | jq -c '.[]' | while read -r obj; do
    KEY=$(echo "$obj" | jq -r '.Key')
    VID=$(echo "$obj" | jq -r '.VersionId')
    aws s3api delete-object --bucket "pet-adoption-state-bucket-one-pet" --key "$KEY" --version-id "$VID" --region "eu-west-3" > /dev/null
  done
fi
echo "✔ Delete markers removed"

# delete dynamodb table
echo "Deleting DynamoDB lock table..."
aws dynamodb delete-table --table-name "pet-adoption-state-bucket-one-dynamodb-lock-pet" --region "eu-west-3" > /dev/null
echo "✔ DynamoDB lock table deleted: pet-adoption-state-bucket-one-dynamodb-lock-pet"

# Step 2 — delete the bucket
aws s3api delete-bucket \
  --bucket "pet-adoption-state-bucket-one-pet" \
  --region "eu-west-3"

echo "✔ Bucket deleted: pet-adoption-state-bucket-one-pet"

