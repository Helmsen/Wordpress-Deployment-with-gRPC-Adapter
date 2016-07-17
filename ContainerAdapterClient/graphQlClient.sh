#!/bin/bash

ftpUser="\"${FTP_USER}\""
ftpPw="\"${FTP_PW}\""
ftpHost="\"${FTP_HOST}\""
ftpPort="\"${FTP_PORT}\""
ftpFilePath="\"${FTP_PATH}\""
keyPairName="\"${KEY_PAIR_NAME}\""
keyId="\"${KEY_ID}\""
keySec="\"${KEY_SECRET}\""
secGroup="\"${SECURITY_GROUP_NAME}\""

region="\"us-west-1\""
os="\"ubuntu\""
dbUserName="\"wordpress\""
dbPw="\"wordpress\""
dbName="\"wordpress\""

echo -e "$newline"
echo "Wait 10 seconds (until adapter is initialized)"
sleep 10

newline="\n";
echo -e "$newline"
echo "# Call createEc2Instances()"
echo "* Response: "
out=$(curl ${GRAPHQL_SERVER_HOST}:${GRAPHQL_SERVER_PORT}/graphql -XPOST -H "Content-Type:application/graphql" --data "{createEc2Instances(service:\"GrpcContainer\", input:{os:${os}, instanceType:\"t2.micro\", keyName:${keyPairName}, secGroup:${secGroup}, numberOfInstances:1, region:${region}, awsAccessKeyId:${keyId}, awsSecretAccessKey:${keySec}}){requestId}}")
requestId=$( echo "$out" | grep "requestId")
requestId="$( sed 's/.*requestId\": \"\(.*\)\"/\1/' <<< $requestId)"
echo "* Request Id: $requestId"

echo -e "$newline"
echo "Wait 10 seconds"
sleep 10

echo -e "$newline"
echo "# Call createEc2InstancesStatus()"
echo "* Response: "
out=$(curl ${GRAPHQL_SERVER_HOST}:${GRAPHQL_SERVER_PORT}/graphql -XPOST -H "Content-Type:application/graphql" --data "{createEc2InstancesStatus(input: {requestId: \"${requestId}\"}){status, result{ instances{ id, publicDns}}}}")
instanceId=$( echo $out | grep id | sed 's/.*\"id\": \"\(.*\)\",.*/\1/')
echo "* InstanceId: $instanceId"

echo -e "$newline"
echo "Wait 210 seconds (until EC2 instances are initialized)"
sleep 210

echo -e "${newline}"
echo "# Call getInstanceDetails()"
echo "* Response:"
out=$(curl ${GRAPHQL_SERVER_HOST}:${GRAPHQL_SERVER_PORT}/graphql -XPOST -H "Content-Type:application/graphql" --data "{getInstanceDetails(service:\"GrpcContainer\", input:{instanceId:\"${instanceId}\", region:${region}, awsAccessKeyId:${keyId}, awsSecretAccessKey:${keySec}}){requestId}}")
requestId=$( echo "$out" | grep "requestId")
requestId="$( sed 's/.*requestId\": \"\(.*\)\"/\1/' <<< $requestId)"
echo "* Request Id: $requestId"

echo -e "$newline"
echo "Wait 10 seconds"
sleep 10

echo -e "${newline}"
echo "# Call getInstanceDetailsStatus()"
echo "* Response:"
out=$(curl ${GRAPHQL_SERVER_HOST}:${GRAPHQL_SERVER_PORT}/graphql -XPOST -H "Content-Type:application/graphql" --data "{getInstanceDetailsStatus(input:{requestId: \"${requestId}\"}){status,result{publicIp, publicDns}}}")
echo "$out"
targetIp=$(echo "$out" | grep "publicIp")
targetIp="$(sed 's/.*publicIp\": \(.*\),/\1/' <<< $targetIp)"
targetDns=$(echo "$out" | grep "publicDns")
targetDns="$(sed 's/.*publicDns\": \"\(.*\)\"/\1/' <<< $targetDns)"
echo "* IP: ${targetIp}"
echo "* DNS: ${targetDns}"

echo -e "$newline"
echo "Wait 10 seconds"
sleep 10

printf "\n"
echo "# Call deployDb()"
echo "Response:"
curl ${GRAPHQL_SERVER_HOST}:${GRAPHQL_SERVER_PORT}/graphql -XPOST -H "Content-Type:application/graphql" --data "{deployDb(service:\"GrpcContainer\", input:{os:$os, hostIp:${targetIp}, privateKey:{host:${ftpHost}, port:${ftpPort}, user:${ftpUser},password:${ftpPw},filePath:${ftpFilePath},__typeFlagBytes__:true}, newUserName:${dbUserName}, newUserPw:${dbPw}, dbName:${dbName}}){requestId}}"

echo -e "$newline"
echo "Wait 300 seconds (until wordpress is deployed - otherwise SaltStack produces an error)"
sleep 300

echo ""
printf "\n"
echo "# Call deployApp()"
echo "Response:"
curl ${GRAPHQL_SERVER_HOST}:${GRAPHQL_SERVER_PORT}/graphql -XPOST -H "Content-Type:application/graphql" --data "{deployApp(service:\"GrpcContainer\", input:{os:$os, hostIp:${targetIp}, privateKey:{host:${ftpHost}, port:${ftpPort}, user:${ftpUser},password:${ftpPw},filePath:${ftpFilePath},__typeFlagBytes__:true }, dbUserName:${dbUserName}, dbUserPw:${dbPw}, dbName:${dbName}, dbHost:\"${targetDns}\"}){requestId}}"
