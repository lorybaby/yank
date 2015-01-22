
MINICONDA=Miniconda-latest-Linux-x86_64.sh
MINICONDA_MD5=$(curl -s http://repo.continuum.io/miniconda/ | grep -A3 $MINICONDA | sed -n '4p' | sed -n 's/ *<td>\(.*\)<\/td> */\1/p')
wget http://repo.continuum.io/miniconda/$MINICONDA
if [[ $MINICONDA_MD5 != $(md5sum $MINICONDA | cut -d ' ' -f 1) ]]; then
    echo "Miniconda MD5 mismatch"
    exit 1
fi
bash $MINICONDA -b
PIP_ARGS="-U"

export PATH=$HOME/miniconda/bin:$PATH

sudo apt-get update
sudo apt-get install -qq -y g++ gfortran csh g++-multilib gcc-multilib openbabel

conda update --yes conda
conda create --yes -n ${python} --file devtools/ci/requirements-conda-${python}.txt
source activate $python
$HOME/miniconda/envs/${python}/bin/pip install $PIP_ARGS -r devtools/ci/requirements-${python}.txt
