#pragma once
#include "mex.h"
#include <vector>
#define INF FLT_MAX

using namespace std;

/********************* ctrl-c handling ***************/
#include <unistd.h>
extern "C" bool utIsInterruptPending();
/******************************************************/

/***********************************************************************/
/***********************************************************************/
/***********************************************************************/
/***********************************************************************/
/***********************************************************************/
/***********************************************************************/

// checking inputs, etc. for errors

bool checkInput(const char *name, const mxArray *in, mxClassID target_class) {
    if (mxGetClassID(in) != target_class) {
        mexPrintf("Input '%s' has wrong class.\n", name);
        return false;
    }
    return true;
}

bool checkInput(const char *name, const mxArray *in, mxClassID target_class, int numel) {
    bool passed = checkInput(name, in, target_class);
    if (passed && (mxGetNumberOfElements(in) != numel)) {
        mexPrintf("Input '%s' has %d elements, when should have %d.\n", 
                name, mxGetNumberOfElements(in), numel);
        passed = false;
    }
    return passed;
}

bool checkInput(const char *name, const mxArray *in, mxClassID target_class, int m, int n) {
    bool passed = checkInput(name, in, target_class);
    if (passed && (mxGetM(in) != m || mxGetN(in) != n)){
        mexPrintf("Input '%s' is %d X %d, should be %d x %d.\n", 
                name, mxGetM(in), mxGetN(in), m, n);
        passed = false;
    }
    return passed;
}

template <typename T> bool checkRange(vector< T > a, T min, T max) {
    for (int i = 0; i < a.size(); i++) {
        if (a[i] < min || a[i] > max)
            return false;
    }
    return true;
}

/***********************************************************************/
/***********************************************************************/
/***********************************************************************/
/***********************************************************************/
/***********************************************************************/
/***********************************************************************/

// Converts a stl vector vector to a Matlab matrix
mxArray* vectorToMxArray(vector<vector<float> > &x) {
    int nRows = x.size();  // i.e., number of rows
    
    if(nRows == 0) {
        mxArray* m = mxCreateDoubleMatrix(0, 0, mxREAL);
        return m;
    }
    
    int nCols = x[0].size();
    
    mxArray* m = mxCreateDoubleMatrix(nRows, nCols, mxREAL);
    for (int i=0; i < nRows; i++) {
        for (int j=0; j < nCols; j++) {
            mxGetPr(m)[j*nRows + i] = x[i][j];
        }
    }
    
    return m;
}

// Converts a stl vector vector to a Matlab matrix
mxArray* vectorToMxArray(vector<vector<double> > &x) {
    int nRows = x.size();  // i.e., number of rows
    
    if(nRows == 0) {
        mxArray* m = mxCreateDoubleMatrix(0, 0, mxREAL);
        return m;
    }
    
    int nCols = x[0].size();
    
    mxArray* m = mxCreateDoubleMatrix(nRows, nCols, mxREAL);
    for (int i=0; i < nRows; i++) {
        for (int j=0; j < nCols; j++) {
            mxGetPr(m)[j*nRows + i] = x[i][j];
        }
    }
    
    return m;
}

template <typename T> mxArray* vectorToMxArray1D(vector<T> x, bool row) {
    
    int nRows = 1, nCols = 1;
    if (!row) nRows = x.size();
    else nCols = x.size();
    
    mxArray *m = mxCreateDoubleMatrix(nRows, nCols, mxREAL);
    for (int i = 0; i < x.size(); i++)
        mxGetPr(m)[i] = x[i];
    
    return m;
}

template <typename T> mxArray* vectorToMxArray1D(vector<T> x) {
    return vectorToMxArray1D(x, false);
}

template <typename T> mxArray* vectorToMxArray2D(vector<T> x, int nRows, int nCols) {

    if ( (nRows*nCols) != x.size() ){
        char buf[1000];
        sprintf(buf, "Cannot create %d x %d matrix from %d elements.\n", nRows, nCols, x.size());
        mexErrMsgTxt(buf);
        
        return (mxArray*)NULL;
    }
    
    mxArray *m = mxCreateDoubleMatrix(nRows, nCols, mxREAL);
    for (int i = 0; i < x.size(); i++)
        mxGetPr(m)[i] = x[i];
    
    return m;
}

/***********************************************************************/
/***********************************************************************/
/***********************************************************************/
/***********************************************************************/
/***********************************************************************/
/***********************************************************************/

// Converts a Matlab matrix to an stl vector
template <typename T> vector<vector<T> > mxarrayToVector2D(const mxArray* m) {
    const int* dims = mxGetDimensions(m);

    int nRows = dims[0];
    int nCols = dims[1];

    //one vector per row of m
    vector<vector<T> > out;
    for (int i=0; i < nRows; i++) {
        out.push_back(vector<T>(nCols,0.0));
        for (int j=0; j < nCols; j++) {
            out[i][j] = (T)mxGetPr(m)[j*nRows + i];
        }
    }
    
    return out;
}

// Converts Matlab matrix to 1-D vector
template <typename T> vector<T> mxarrayToVector1D(const mxArray* m) {
    const int numel = mxGetNumberOfElements(m);

    // one vector per row of m
    vector<T> out(numel, 0.0);
    for (int i = 0; i < numel; i++)
        out[i] = (T)mxGetPr(m)[i];

    return out;
}

// Convert Matlab cell matrix to vector of vectors
template <typename T> vector< vector<T> > mxarrayCellToVector(const mxArray* m, mxClassID target_class, bool &passed) {
    const int numel = mxGetNumberOfElements(m);

    passed = true;

    char buf[1000];
    
    // one vector per row of m
    vector< vector<T> > out;
    for (int i = 0; i < numel; i++) {
        mxArray *cell = mxGetCell(m, i);
    
        if (cell == NULL) {
            passed = false; 
            return out;
        }
        
        sprintf(buf, "cell[%d]", i);
        
        int n = mxGetNumberOfElements(cell);
        if (checkInput(buf, cell, target_class))
            out.push_back(mxarrayToVector1D< T >(cell));
        else {
            passed = false;
            return out;
        }
    }

    return out;
}

/***********************************************************************/
/***********************************************************************/
/***********************************************************************/
/***********************************************************************/
/***********************************************************************/
/***********************************************************************/

// Useful math utils

pair<float, int> max_argmax(const vector<float>& v){
    float maxval = -INF;
    int argmax = -1;
    for(int i=0; i<v.size(); i++){
        if(v[i] > maxval){
            maxval = v[i];
            argmax = i;
        }
    }
    return pair<float,int>(maxval,argmax);
}

pair<float, int> max_argmax(const vector<float>& v, const vector<int>& idx){
    float maxval = -INF;
    int argmax = -1;
    for(int i=0; i<idx.size(); i++){
        
        if (idx[i] >= v.size()) {
            mexPrintf("out of bounds!\n"); continue;
        }
        
        if(v[idx[i]] > maxval){
            maxval = v[idx[i]];
            argmax = idx[i];
        }
    }
    return pair<float,int>(maxval,argmax);
}

float dot(vector<float>& a, vector<float>& b){
    float v = 0;
    for(int i=0; i< a.size(); i++){
         v += a[i]*b[i];
    }
    return v;
}

void add(vector<float>& a, const vector<float>& b, float scalar){
    for(int i=0; i< a.size(); i++){
        a[i] += scalar*b[i];
    }
}

void mult(vector<float>& a, float scalar){
    for(int i=0; i< a.size(); i++){
        a[i] *= scalar;
    }
}

float norm2(vector<vector<float> >& W){
    float nw = 0;
    for(int i=0; i<W.size();i++){
        for(int j=0; j<W[0].size();j++){
            nw += W[i][j]*W[i][j];
        }
    }
    return nw;
}

template <typename T> void increment(vector<T> &a, T offset) {
    for (int i = 0; i < a.size(); i++) {
        a[i] += offset;
    }
}
