""" Setup module for MATRIX Labs protos

See:
https://github.com/matrix-io/protocol-buffers
"""

import setuptools

from setuptools import setup, find_packages

install_requires = [
  'protobuf>=3.2.0'
]

extras_require = {
  'grpc': ['grpcio>=1.2.0']
}

setuptools.setup(
  name='matrix_io-proto',
  version='0.0.10',

  author='MATRIX Labs',
  author_email='devel@matrixlabs.ai',
  classifiers=[
    'Development Status :: 4 - Beta',
    'Intended Audience :: Developers',
    'License :: OSI Approved :: GNU General Public License v3 (GPLv3)',
    'Programming Language :: Python',
    'Programming Language :: Python :: 2',
    'Programming Language :: Python :: 2.7',
    'Programming Language :: Python :: 3',
    'Programming Language :: Python :: 3.4',
    'Programming Language :: Python :: 3.5',
    'Programming Language :: Python :: 3.6',
  ],
  description='Protobufs used MATRIX ecosystem',
  long_description=open('README.rst').read(),
  install_requires=install_requires,
  extras_require=extras_require,
  license='GPLv3',
  namespace_packages=[
    'matrix_io.proto',
    'matrix_io',
  ],
  packages=find_packages(),
  url='https://github.com/matrix-io/protocol-buffers'
)
