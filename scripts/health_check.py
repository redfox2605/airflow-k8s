import requests, sys
res = requests.get('http://localhost:8080/health').json()
sys.exit(0 if res['scheduler']['status'] == 'healthy' else 1)