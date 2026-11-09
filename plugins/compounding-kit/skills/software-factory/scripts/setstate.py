#!/usr/bin/env python3
# usage: setstate.py <job.json> key=value ...   e.g. stage=review round=2 reviews=pending ux=PASS
# "reviews=pending" resets all four; security/ux/ui/code=VALUE sets one review.
import json,sys
p=sys.argv[1]; d=json.load(open(p))
for kv in sys.argv[2:]:
    k,v=kv.split('=',1)
    if k=='reviews': d['reviews']={r:v for r in ['security','ux','ui','code']}
    elif k in ('security','ux','ui','code'): d['reviews'][k]=v
    elif k=='round': d['round']=int(v)
    else: d[k]=v
json.dump(d,open(p,'w')); print(d['stage'],d['round'],d['reviews'])
