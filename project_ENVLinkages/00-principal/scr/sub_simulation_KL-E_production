
* File:   project_ENVLinkages/simulation/sub_simulation_KL-E_production.gms
* Author: Tatyana Bulavskaya
* Date:   25 June 2015

$ontext startdoc

$offtext


* ======== Declaration and definition of simulation specific parameters ========
Sets
    ener(prd)    energy products products
/
p023
p030
/
;


* Additional parameters for KL-E production functions
Parameters
    elasKLE(regg,ind)           substitution elasticity between capital-labour
                                # and energy nests
    elasE(regg,ind)             substitution elasticity between types of
                                # energy
    eprod(prd,regg,ind)         energy productivity
    nKLE(regg,ind)              intermediate use of capital-labour-energy
                                # nest (volume)
    nENER(regg,ind)             intermediate use of aggregated energy
                                # (volume)
    aKLE(regg,ind)              technical input coefficients for aggregated
                                # capital-labour-energy nest (relation in
                                # volume)
    aE(regg,ind)                relative share parameter for energy nest within
                                # the aggregated KLE nest (relation in volume)
    aKL(regg,ind)               relative share parameter for factors of
                                # production nest with the aggregated KLE nest
                                # (relation in volume)
    alphaE(ener,regg,ind)       relative share parameter for types of
                                # energy within the aggregated nest (relation
                                # in volume)
    alphaKL(reg,va,regg,ind)    relative share parameter for factors of
                                # production within the aggregated nest
                                # (relation in volume)
;

* For elasticity value we have taken industry averages from EPPA6 model.
* Initial energy productivity is calibrated to 1.
elasKLE(regg,ind)    = 0.4 ;
elasE(regg,ind)      = 0.5 ;
eprod(ener,regg,ind) = 1 ;


* Aggregate intermediate consumption of energy in each industry (ind) in each
* region (regg), the corresponding basic price in the calibration year is equal
* to 1.
nENER(regg,ind)
    = sum(ener, INTER_USE_T(ener,regg,ind) + INTER_USE_dt(ener,regg,ind) ) ;

* Aggregate intermediate consumption of capital-labour-energy bundle in each
* industry (ind) in each region (regg), the corresponding basic price in the
* calibration year is equal to 1.
nKLE(regg,ind)
    = nENER(regg,ind) + sum((reg,kl), VALUE_ADDED(reg,kl,regg,ind) ) ;

Display
nKLE
nENER
;


* Leontief technical input coefficients for the nest of capital-labour-energy
* bundle in each industry (ind) in each region (regg).
aKLE(regg,ind)$nKLE(regg,ind)
    = nKLE(regg,ind) / Y(regg,ind) ;

* Relative share parameter for the nest of aggregated energy within the
* capital-labour-energy nest in each industry (ind) in each region (regg).
aE(regg,ind)$nENER(regg,ind)
    = nENER(regg,ind) / nKLE(regg,ind) ;

* Relative share parameter for the nest of aggregated factors of production
* within the capital-labour-energy nest in each industry (ind) in each region
* (regg).
aKL(regg,ind)$sum((reg,kl), VALUE_ADDED(reg,kl,regg,ind) )
    = sum((reg,kl), VALUE_ADDED(reg,kl,regg,ind) ) / nKLE(regg,ind) ;

* Relative share parameter for types of energy within the aggregated energy nest
* for each type of energy (ener) in each industry (ind) in each region (regg).
alphaE(ener,regg,ind)$INTER_USE_T(ener,regg,ind)
    = INTER_USE_T(ener,regg,ind) / ( nENER(regg,ind) / eprod(ener,regg,ind) ) *
    ( 1 * eprod(ener,regg,ind) /
    ( 1 + tc_ind(ener,regg,ind) ) )**( -elasE(regg,ind) ) ;

* Relative share parameter for factors of production within the aggregated nest
* for each type of production factor (reg,kl) in each industry (ind) in each
* region (regg).
alphaKL(reg,kl,regg,ind)$VALUE_ADDED(reg,kl,regg,ind)
    = VALUE_ADDED(reg,kl,regg,ind) /
    ( sum((reggg,kll), VALUE_ADDED(reggg,kll,regg,ind) ) /
    fprod(kl,regg,ind) )  *
    fprod(kl,regg,ind)**( -elasKL(regg,ind) ) ;

Display
aKLE
aE
aKL
alphaE
alphaKL
;


* =============== Define simulation specific variables/equations ===============

Variables
    nKLE_V(regg,ind)            use of aggregated capital-labour-energy nest
    nENER_V(regg,ind)           use of aggregated energy nest
    ENER_V(prd,regg,ind)        use of energy types
    PENER_V(regg,ind)           aggregate energy price
    PKLE_V(regg,ind)            aggregate capital-labour-energy price

;

Equations
    EQINTU_T_ener(prd,regg,ind) demand for intermediate inputs on aggregated
                                # product level
    EQnKLE(regg,ind)            demand for aggregated capital-labour-energy nest
    EQnENER(regg,ind)           demand for aggregated energy nest
    EQVA_ener(regg,ind)         demand for aggregated production factors
    EQENER(prd,regg,ind)        demand for energy types
    EQPENER(regg,ind)           balance between price per energy type and
                                # aggregate energy price
    EQPKLE(regg,ind)            balance between aggregate energy price and
                                # aggregate production factors price and
                                # aggregate capital-labour-energy price
;

* EQUATION 1.3a: Demand for intermediate inputs on aggregated product level. For
* non-energy products the demand function follows Leontief form, where the
* relation between intermediate inputs of aggregated product (prd) and output of
* the industry (regg,ind) in volume is kept constant. The demand for energy
* products (ener) comes from the solution for capital-labour-energy nest.
EQINTU_T_ener(prd,regg,ind)..
    INTER_USE_T_V(prd,regg,ind)
    =E=
    ioc(prd,regg,ind) * Y_V(regg,ind)$( not ener(prd) ) +
    ENER_V(prd,regg,ind)$ener(prd) ;

* EQUATION 2.1a: Demand for aggregated capital-labour-energy nest. The demand
* function follows Leontief form, where the relation between aggregated KLE and
* output of the industry (regg,ind) in volume is kept constant.
EQnKLE(regg,ind)..
    nKLE_V(regg,ind)
    =E=
    aKLE(regg,ind) * Y_V(regg,ind) ;

* EQUATION 2.1b: Demand for aggregated energy nest. The demand function follows
* CES form, where demand for aggregated energy of each industry (regg,ind)
* depends linearly on the demand of the same industry for aggregated KLE nest
* and with certain elasticity on relative prices of energy, capital and labour.
EQnENER(regg,ind)..
    nENER_V(regg,ind)
    =E=
    nKLE_V(regg,ind) * aE(regg,ind) *
    ( PENER_V(regg,ind) / PKLE_V(regg,ind) )**( -elasKLE(regg,ind) ) ;

* EQUATION 2.1c: Demand for aggregated production factors (capital-labour). The
* demand function follows CES form, where demand for aggregated production
* factors of each industry (regg,ind) depends linearly on the demand of the same
* industry for aggregated KLE nest and with certain elasticity on relative
* prices of energy, capital and labour.
EQVA_ener(regg,ind)..
    VA_V(regg,ind)
    =E=
    nKLE_V(regg,ind) * aKL(regg,ind) *
    ( PVA_V(regg,ind) / PKLE_V(regg,ind) )**( -elasKLE(regg,ind) ) ;

* EQUATION 2.1d: Demand for types of energy. The demand function follows CES
* form, where demand of each industry (regg,ind) for each type of energy (ener)
* depends linearly on the demand of the same industry for aggregated energy nest
* and with certain elasticity on relative prices of energy types. The demand for
* energy types is also augmented with exogenous level of energy productivity.
EQENER(ener,regg,ind)..
    ENER_V(ener,regg,ind)
    =E=
    ( nENER_V(regg,ind) / eprod(ener,regg,ind) ) * alphaE(ener,regg,ind) *
    ( PIU_V(ener,regg,ind) * ( 1 + tc_ind(ener,regg,ind) ) /
    ( eprod(ener,regg,ind) * PENER_V(regg,ind) ) )**( -elasE(regg,ind) ) ;

* EQUATION 10.4a: Balance between price per energy type and aggregate energy
* price. The aggregate price is different in each industry (ind) in each region
* (regg) and is a weighted average of the price per type of energy, where
* weights are defined as demand by the industry for the corresponding types of
* energy.
EQPENER(regg,ind)..
    PENER_V(regg,ind) * nENER_V(regg,ind)
    =E=
    sum(ener, PIU_V(ener,regg,ind) * ( 1 + tc_ind(ener,regg,ind) ) *
    ENER_V(ener,regg,ind) ) ;

* EQUATION 10.4b: Balance between aggregate energy price, aggregate production
* factors price and aggregate capital-labour-energy price. The aggregate KLE
* price is different in each industry (ind) in each region (regg) and is a
* weighted average KL and E prices, where weights are defined as demand by the
* industry for the corresponding nests.
EQPKLE(regg,ind)..
    PKLE_V(regg,ind) * nKLE_V(regg,ind)
    =E=
    PENER_V(regg,ind) * nENER_V(regg,ind) + PVA_V(regg,ind) * VA_V(regg,ind) ;


* Initial levels
nKLE_V.L(regg,ind)      = nKLE(regg,ind) ;
nENER_V.L(regg,ind)     = nENER(regg,ind)  ;
ENER_V.L(ener,regg,ind) = INTER_USE_T(ener,regg,ind) ;

nKLE_V.FX(regg,ind)$(nKLE(regg,ind) eq 0)                  = 0 ;
nENER_V.FX(regg,ind)$(nENER(regg,ind) eq 0)                = 0 ;
ENER_V.FX(ener,regg,ind)$(INTER_USE_T(ener,regg,ind) eq 0) = 0 ;

PENER_V.L(regg,ind) = 1 ;
PKLE_V.L(regg,ind)  = 1 ;

PENER_V.FX(regg,ind)$(nENER_V.L(regg,ind) eq 0) = 1 ;
PKLE_V.FX(regg,ind)$(nKLE_V.L(regg,ind) eq 0)   = 1 ;


* Scaling
* EQUATION 1.3a
EQINTU_T_ener.SCALE(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) gt 0)
    = INTER_USE_T_V.L(prd,regg,ind) ;

EQINTU_T_ener.SCALE(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) lt 0)
    = -INTER_USE_T_V.L(prd,regg,ind) ;

* EQUATION 2.1a
EQnKLE.SCALE(regg,ind)$(nKLE_V.L(regg,ind) gt 0)
    = nKLE_V.L(regg,ind) ;
nKLE_V.SCALE(regg,ind)$(nKLE_V.L(regg,ind) gt 0)
    = nKLE_V.L(regg,ind) ;

EQnKLE.SCALE(regg,ind)$(nKLE_V.L(regg,ind) lt 0)
    = -nKLE_V.L(regg,ind) ;
nKLE_V.SCALE(regg,ind)$(nKLE_V.L(regg,ind) lt 0)
    = -nKLE_V.L(regg,ind) ;

* EQUATION 2.1b
EQnENER.SCALE(regg,ind)$(nENER_V.L(regg,ind) gt 0)
    = nENER_V.L(regg,ind) ;
nENER_V.SCALE(regg,ind)$(nENER_V.L(regg,ind) gt 0)
    = nENER_V.L(regg,ind) ;

EQnENER.SCALE(regg,ind)$(nENER_V.L(regg,ind) lt 0)
    = -nENER_V.L(regg,ind) ;
nENER_V.SCALE(regg,ind)$(nENER_V.L(regg,ind) lt 0)
    = -nENER_V.L(regg,ind) ;

* EQUATION 2.1c
EQVA_ener.SCALE(regg,ind)$(VA_V.L(regg,ind) gt 0)
    = VA_V.L(regg,ind) ;

EQVA_ener.SCALE(regg,ind)$(VA_V.L(regg,ind) lt 0)
    = -VA_V.L(regg,ind) ;

* EQUATION 2.1d
EQENER.SCALE(ener,regg,ind)$(ENER_V.L(ener,regg,ind) gt 0)
    = ENER_V.L(ener,regg,ind) ;
ENER_V.SCALE(ener,regg,ind)$(ENER_V.L(ener,regg,ind) gt 0)
    = ENER_V.L(ener,regg,ind) ;

EQENER.SCALE(ener,regg,ind)$(ENER_V.L(ener,regg,ind) lt 0)
    = -ENER_V.L(ener,regg,ind) ;
ENER_V.SCALE(ener,regg,ind)$(ENER_V.L(ener,regg,ind) lt 0)
    = -ENER_V.L(ener,regg,ind) ;

* EQUATION 10.4a
EQPENER.SCALE(reg,ind)$(nENER_V.L(reg,ind) gt 0)
    = nENER_V.L(reg,ind) ;

EQPENER.SCALE(reg,ind)$(nENER_V.L(reg,ind) lt 0)
    = -nENER_V.L(reg,ind) ;

* EQUATION 10.4b
EQPKLE.SCALE(reg,ind)$(nKLE_V.L(reg,ind) gt 0)
    = nKLE_V.L(reg,ind) ;

EQPKLE.SCALE(reg,ind)$(nKLE_V.L(reg,ind) lt 0)
    = -nKLE_V.L(reg,ind) ;
