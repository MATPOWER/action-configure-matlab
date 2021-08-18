Configure MATLAB
================

### GitHub Action to finish configuring [MATLAB][1]

Sets the following environment variables.
- `MATLAB_REL` set to the release name (e.g. `'R2021a'`) of installed
  [MATLAB][1]
- `MATLAB_VER` set to the version (e.g. `'9.1.0'`) of installed [MATLAB][1],
- `IS_MATLAB` set to 1
- `IS_OCTAVE` set to 0
- `ML_NAME` set to `MATLAB`
- `ML_VER` set to same as `MATLAB_VER`
- `ML_CMD` set to `/usr/local/MATLAB/${MATLAB_REL}/bin/matlab -nojvm -batch`
- `ML_PATHVAR` set to `MATLABPATH`
  _(currently set equal to release name instead)_

__Note:__ This action depends on [MATLAB][1] being installed first, using
[`matlab-actions/setup-matlab`][2].

### Inputs / Outputs

None.

### Example Usage
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

[1]: https://mathworks.com
[2]: https://github.com/marketplace/actions/setup-matlab
