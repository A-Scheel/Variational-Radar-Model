# Variational Radar Model

This repository provides MATLAB code that accompanies the paper "Tracking Multiple Vehicles Using a Variational Radar Model" by Alexander Scheel and Klaus Dietmayer. See below for the full citation. The variational radar model provides a probabilistic model of radar measurements (i.e. radar detections) from vehicles. It can be used for tracking other vehicles in autonomous driving and driver assistance system applications. The repository contains the model itself as well as scripts for ploting different densities that can be deduced. Please refer to the paper for a detailed description of the model.

Paper reference:
Alexander Scheel and Klaus Dietmayer, "Tracking Multiple Vehicles Using a Variational Radar Model", in IEEE Transactions on Intelligent Transportation Systems, vol. 20, no. 10, pp. 3721-3736, Oct. 2019.

## Prerequisites

As the code is implemented in MATLAB, an installed MATLAB version is necessary. The code has been tested for the MATLAB versions R2016a and R2017a. 

## Structure and Usage

The variational radar model itself is provided as .mat-File in the folder model/. It is given as four-dimensional Student's t mixture where the dimensions are  
1: x'   - aspect angle under which the sensor sees the vehicle,  
2: z'_x - x-coordinate of the measurement in object coordinates,  
3: z'_y - y-coordinate of the measurement in object coordinates,  
4: z'_d - Doppler error.

The mixture density is a struct with fields  
roh    - vector of mixing coefficients,  
gamma  - 4x50 matrix where the i-th column contains the mean vector of the i-th Student's t density,  
nu     - vector of degrees of freedom, the i-th entry corresponds to the i-th component,  
Htilde - 4x4x50 matrix where the i-th slice contains the precision matrix of the i-th component.

The script plotVariationalRadarModel.m creates exemplary views of the model by computing different marginal and conditional densities.

Functions for computing marginal and conditional densities as well as for evaluating the Student's t mixtures are stored in the folder src/.

## License and Citations

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

Please cite our original paper if you use our code for your research.

@misc{Scheel.2019,  
 author = {Scheel, Alexander and Dietmayer, Klaus},  
 journal={IEEE Transactions on Intelligent Transportation Systems},  
 title={Tracking Multiple Vehicles Using a Variational Radar Model},  
 year={2019},  
 month={Oct},  
 volume={20},  
 number={10},  
 pages={3721-3736}  
}
