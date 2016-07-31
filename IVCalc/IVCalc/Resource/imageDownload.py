import urllib

for i in range(1, 152):
  urllib.urlretrieve('http://www.serebii.net/pokearth/sprites/green/{0:03d}.png'.format(i), '{}.png'.format(i))