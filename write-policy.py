#!/usr/bin/env python3

import sys
import json

# ENTER YOUR HEX PUBKEY(S) BELOW:
whitelist = {
      '003ba9b2c5bd8afeed41a4ce362a8b7fc3ab59c25b6a1359cae9093f296dac01': true,
      '3d99feac152027ede63326aa4f43d4ca88e4cd27296b96fe18c55d496a8f6340': true,
}

def eprint(*args, **kwargs):
  print(*args, **kwargs, file=sys.stderr, flush=True)

def accept(request):
  response = {
    'id' : request['event']['id']
  }

  response['action'] = 'accept'
  r = json.dumps(response,separators=(',', ':')) # output JSONL
  print(r, end='\n', file=sys.stdout, flush=True)

def reject(request):
  response = {
    'id' : request['event']['id']
  }

  response['action'] = 'reject'
  response['msg'] = f"blocked: pubkey {request['event']['pubkey']} not in whitelist | SOURCE: {request['sourceInfo']}"
  r = json.dumps(response,separators=(',', ':')) # output JSONL
  print(r, end='\n', file=sys.stdout, flush=True)

def main():
  for line in sys.stdin:
    request = json.loads(line)

    try:
      if request['type'] == 'lookback':
        continue
    except KeyError:
      eprint("input without type in write policy plugin")
      continue

    if request['type'] != 'new':
      eprint("unexpected request type in write policy plugin")
      continue

    try:
      if not request['event']['id']:
        eprint("input without event id in write policy plugin")
        continue
    except KeyError:
      eprint("input without event id in write policy plugin")
      continue

    try:
      if request['event']['pubkey'] in whitelist:
        accept(request)
        continue
      elif int(request['event']['kind']) == 10002:
        accept(request)
        continue
      elif request.get("event", {}).get("tags"):
        if p_tags:= [x for x in request['event']['tags'] if x[0] == 'p']:
          pubkeys = [x[1] for x in p_tags]
          if whitelist.intersection(pubkeys):
            accept(request)
            continue
        reject(request)
        continue
      else:
        reject(request)
        continue
    except KeyError:
      eprint("poorly formed event input in write policy plugin")
      continue

if __name__=='__main__':
  main()
