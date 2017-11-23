import json
import lxml.etree as et
import click
import os
import shutil
import warnings
from collections import OrderedDict


@click.command()
@click.argument('files', nargs=-1)
@click.option('--kind')
def cmd_convert(files, kind):
   files = sorted(files)
   output = {}
   fail_dir = 'symbols_too_large'
   
   for file in files:
      if not os.path.exists(file):
         continue
      try:
         with open(file, 'rb') as fp:
            root = et.parse(fp)
      except:
         raise click.ClickException('Failed to read {0}'.format(file))
      
      if os.stat(file).st_size > 1536:
         click.echo('File too large for inclusion {0}'.format(file), err=True)
         fail_dir_extended = fail_dir+'/'+os.path.dirname(file)
         if not os.path.exists(fail_dir_extended):
             os.makedirs(fail_dir_extended)
         shutil.move(file, fail_dir+'/'+file)
         continue
     
      el = root.find('a:path', namespaces={'a':'http://www.w3.org/2000/svg'})
      path = el.attrib['d']
      nickname = os.path.splitext(os.path.basename(file))[0]    \
                    .replace('_', '-').replace(' ', '-')        \
                    .replace('_Copy', '').replace('svg', '')    \
                    .replace('--', '-').lower()
      for i in range(0, 9):
        nickname = nickname.replace('({})'.format(i), '').strip('- ')
      key = '{0}-{1}'.format(kind, nickname)
      key = key
      output[key] = OrderedDict([
        ('name',  nickname.replace('-', ' ').title()),
        ('tags', [kind]),
        ('category', kind.capitalize()),
        ('path', path),
        ('bbox', dict(x=0,y=0,x2=512,y2=512,width=512,height=512,cx=256,cy=256)),
        ('scale', 0.046875),
        ('strokeWidth', 6),
      ])
   click.echo(json.dumps(output, indent=True))

if __name__ == '__main__':
  cmd_convert()
