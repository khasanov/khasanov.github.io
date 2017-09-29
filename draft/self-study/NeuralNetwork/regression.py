from urllib.request import urlopen
import numpy as np

filename = 'boston_houses.csv'#input()
#f = urlopen('https://stepic.org/media/attachments/lesson/16462/boston_houses.csv')
f = open(filename)

data = np.loadtxt(f, delimiter=",", skiprows=1)

# y = b0 + b1*x1 + b2*x2 + ... + bN*xN

y = data[:, 0:1] # first column
x0 = np.ones_like(y)
x = np.hstack((x0, data[:, 1:])) # add column with zeroes to handle b0

b = np.linalg.inv(x.T.dot(x)).dot(x.T).dot(y) # https://en.wikipedia.org/wiki/Ordinary_least_squares

print(" ".join(map(str, b.flatten())))
