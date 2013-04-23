#include "mex.h"
#include "mex_utils.h"
#include <stdio.h>
#include <vector>

/***********************************************************************/
/***********************************************************************/

void print_usage() {
    mexPrintf("usage: [sum npts] = mex_sum_line(X, p1, p2, i, j, n)\n");
    mexPrintf("   - X = double(n x m)\n");
    mexPrintf("   - p1,p2 = double(2 x k1), double(2 x k2)\n");
    mexPrintf("   - i,j = double(d x 1) indices into 1...k1, 1...k2\n");
    mexErrMsgTxt("**** improper usage detected.\n");
}

void mexFunction(int nlhs, mxArray *out[], int nrhs, const mxArray *in[]){

    if (nrhs != 6 || nlhs != 2){
        print_usage();
        return;
    }
    
    if (!checkInput("X", in[0], mxDOUBLE_CLASS)) {
        print_usage(); return;
    }
    if (!checkInput("p1", in[1], mxDOUBLE_CLASS, 2, mxGetN(in[1]))) {
        print_usage(); return;
    }
    if (!checkInput("p2", in[2], mxDOUBLE_CLASS, 2, mxGetN(in[2]))) {
        print_usage(); return;
    }
    if (!checkInput("i", in[3], mxDOUBLE_CLASS, mxGetM(in[3]), 1)) {
        print_usage(); return;
    }
    if (!checkInput("j", in[4], mxDOUBLE_CLASS, mxGetM(in[3]), 1)) {
        print_usage(); return;
    }
    if (!checkInput("n", in[5], mxDOUBLE_CLASS, 1)) {
        print_usage(); return;
    }
    
    vector<vector<double> > X = mxarrayToVector2D<double>(in[0]);
    vector<vector<int> > p1 = mxarrayToVector2D<int>(in[1]);
    vector<vector<int> > p2 = mxarrayToVector2D<int>(in[2]);
    vector<int> inds_i = mxarrayToVector1D<int>(in[3]);
    vector<int> inds_j = mxarrayToVector1D<int>(in[4]);
    double n_interp = mxGetScalar(in[5]);

    int nrows = X.size(); int ncols = X[0].size();
    int k1 = p1[0].size(); int k2 = p2[0].size();
    int n_pairs = inds_i.size();
    
    if (!checkRange<int>(p1[0], 1, ncols) || !checkRange<int>(p1[1], 1, nrows)) {
        mexErrMsgTxt("Error: p1 is out of range\n"); return;
    }

    if (!checkRange<int>(p2[0], 1, ncols) || !checkRange<int>(p2[1], 1, nrows)) {
        mexErrMsgTxt("Error: p2 is out of range\n"); return;
    }

    if (!checkRange<int>(inds_i, 1, k1)) {
        mexErrMsgTxt("i is out of range \n"); return; 
    }
    if (!checkRange<int>(inds_j, 1, k2)) {
        mexErrMsgTxt("j is out of range\n"); return; 
    }

    vector<double> sums(n_pairs, 0.0);
    vector<int> npts(n_pairs, 0.0);
    
    float step = 1.0 / (n_interp-1);
    
    for (int i = 0; i < n_pairs; i++) {
        
        int ind1 = inds_i[i]-1;
        int ind2 = inds_j[i]-1;
        
        int x1 = p1[0][ind1]-1, x2 = p2[0][ind2]-1;
        int y1 = p1[1][ind1]-1, y2 = p2[1][ind2]-1;
        
        //mexPrintf("(%d,%d)--(%d,%d)\n",x1,y1,x2,y2);
        
        float dir_x = (x2 - x1)*step;
        float dir_y = (y2 - y1)*step;
        
        int oldx = -1; int oldy = -1; 
    
        for (float k = 0; k < n_interp; k++) {
            int x = x1 + dir_x*k;
            int y = y1 + dir_y*k;
            
            if (x == oldx && y == oldy)
                continue;
            oldx = x; oldy = y;
            
            //mexPrintf("\t(%d,%d)\n", x+1,y+1);
            
            sums[i] += X[y][x];
            npts[i]++;
        }
    }
    
    out[0] = vectorToMxArray1D<double>(sums);
    out[1] = vectorToMxArray1D<int>(npts);
    
//             sprintf(buf, "seg[%d] = %d is out of bounds!\n", i, idx);
//             mexErrMsgTxt(buf);
//             return;
}