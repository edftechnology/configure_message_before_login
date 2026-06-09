# -*- coding: utf-8 -*-

"""
Módulo de configuração básica.
"""

from setuptools import setup

def readme():

    """
    Função LEIA-ME.
    """

    with open('README.md') as file:
        return file.read()

setup(name='configure message before login',
      version='1.0.0',
      description='Configurar uma mensagem antes do login no Linux Ubuntu.',
      long_description=readme(),
      classifiers=[
        'Development Status :: 5 - Production/Stable',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 3',
        'Topic :: System :: Systems Administration'],
      url='https://github.com/edeneden/configure_message_before_login',
      author='Eden Denis F. da S. L. Santos',
      author_email='eden.denis@edftechnology.com',
      license='MIT',
      packages=[],
      python_requires='>=3.6',
      install_requires=[],
      include_package_data=True,
      zip_safe=False)
