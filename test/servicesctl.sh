service=${1:-web}
action=${2:-register}

if [ "$action" = "register" ]; then
  echo "Registering service ${service}_1"
  curl -X PUT -H "Content-Type: application/json" --data @test/${service}-service.json http://127.0.0.1:8501/v1/agent/service/register?replace-existing-checks=true
else
  echo "Unregistering service ${service}_1"
  curl -X PUT -H "Content-Type: application/json" http://127.0.0.1:8501/v1/agent/service/deregister/${service}_1
fi
