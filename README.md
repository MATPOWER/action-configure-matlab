Configure MATLAB
================

### GitHub Action to configure [MATLAB][1]

Configures MATLAB by defining environment variables and optionally
installing some 3rd party solvers.

Optionally installs the MATLAB interface for COIN-OR's [IPOPT][2] and
defines the `IPOPT_PATH` environment variable to point to the directory
containing the [IPOPT][2] MEX- and M-files.

Optionally installs the MATLAB interface for [OSQP][3] and defines the
`OSQP_PATH` environment variable to point to the directory containing the
[OSQP][3] MEX- and M-files.

Sets the following environment variables.
- `MATLAB_REL` set to the release name (e.g. `'R2021a'`) of installed
  [MATLAB][1]
- `MATLAB_VER` set to the version (e.g. `'9.1.0'`) of installed [MATLAB][1],
- `ML_NAME` set to `MATLAB`
- `ML_VER` set to same as `MATLAB_VER`
- `ML_CMD` set to `/usr/local/MATLAB/${MATLAB_REL}/bin/matlab -nojvm -batch`
- `ML_PATHVAR` set to `MATLABPATH`
- `IPOPT_PATH` set to `$HOME/build/ipopt` (if `ipopt` input is `true`)
- `OSQP_PATH` set to `$HOME/build/osqp-matlab` (if `osqp` input is `true`)
  _(currently set equal to release name instead)_

__Note:__ This action depends on [MATLAB][1] being installed first, using
[`matlab-actions/setup-matlab`][4] and currently, as of Aug 25, 2021, works
on  `ubuntu-18.04`, `ubuntu-20.04` and `ubuntu-latest`.

### Optional Inputs

- `os` - (default `'ubuntu-latest'`) required if `ipopt` is `true` to
  distinguish `ubuntu-18.04` from `ubuntu-20.04`/`ubuntu-latest`
- `nojvm` - (default `true`) set to `false` to exclude the `-nojvm` flag
  from the definition of `ML_CMD`
- `ipopt` - (default `false`) if true, include IPOPT interface in
  `~/build/ipopt`
- `ipopt-cached` - (default `false`) install IPOPT interface from cached build,
  if true and `ipopt` is `true`
- `osqp` - (default `false`) if true, include OSQP interface, in
  `~/build/osqp-matlab`
- `osqp-cached` - (default `false`) install OSQP interface from cached build,
  if true and `osqp` is `true`

### Outputs

None.

### Example Usage
Default Inputs
```
    steps:
    - name: Install MATLAB
      uses: matlab-actions/setup-matlab@v1

    - name: Configure MATLAB
      uses: MATPOWER/action-configure-matlab@v1

    - name: MATLAB ${{ env.ML_VER }} Installed
      run: $ML_CMD ver

    - name: Run MATLAB script with path
      run: |
        export MY_PATH=<path-to-my-MATLAB-code>
        env $ML_PATHNAME=$MY_PATH $ML_CMD <my-MATLAB-script>
```

With support for JVM, IPOPT, and OSQP
```
    strategy:
      fail-fast: false
      matrix:
        platform: [matlab]
        os: [ubuntu-18.04, ubuntu-20.04, ubuntu-latest]

    runs-on: ${{ matrix.os }}

    steps:
    - name: Cache IPOPT interface
      id: cache-ipopt
      env:
        cache-name: ipopt
      uses: actions/cache@v3
      with:
        path: ~/build/ipopt
        key: ${{ env.cache-name }}-${{ matrix.platform }}-${{ matrix.os }}

    - name: Cache OSQP interface
      id: cache-osqp
      env:
        cache-name: osqp
      uses: actions/cache@v3
      with:
        path: ~/build/osqp-matlab
        key: ${{ env.cache-name }}-${{ matrix.platform }}-${{ matrix.os }}

    - name: Install MATLAB
      uses: matlab-actions/setup-matlab@v1

    - name: Configure MATLAB
      if: matrix.platform == 'matlab'
      uses: MATPOWER/action-configure-matlab@v1
      with:
        os: ${{ matrix.os }}
        nojvm: false
        ipopt: ${{ env.INCLUDE_IPOPT == 1 }}
        ipopt-cached: ${{ steps.cache-ipopt.outputs.cache-hit == 'true' }}
        osqp: ${{ env.INCLUDE_OSQP == 1 }}
        osqp-cached: ${{ steps.cache-osqp.outputs.cache-hit == 'true' }}

    - name: MATLAB ${{ env.ML_VER }} Installed
      run: $ML_CMD ver

    - name: Run MATLAB script with path
      run: |
        $ML_CMD "fprintf('OSQP Version %s installed\n', osqp().version)"
        export MY_PATH=<path-to-my-MATLAB-code>
        env $ML_PATHNAME=$MY_PATH $ML_CMD <my-MATLAB-script>
```

[1]: https://mathworks.com
[2]: https://github.com/coin-or/Ipopt
[3]: https://osqp.org
[4]: https://github.com/marketplace/actions/setup-matlab
