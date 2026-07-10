import importlib.metadata as m
fake={'paysafe-sdk','paysafe-api','paysafe-payments','paysafe-kyc'}
inst={d.metadata['Name'].lower():d.version for d in m.distributions()}
found=False
for p in sorted(fake):
    if p in inst:
        print('FOUND:',p,inst[p]);found=True
if not found: print('No reported PyPI packages detected.')
