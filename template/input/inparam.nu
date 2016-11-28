# inparam.nu
# created by Kuangdai on 28-Jun-2016 
# parameters for the integer field Nu(s,z) 
# NOTE:
# a) angles are measured in degrees and distances in kilometers
# b) string-typed parameters (except file names) are case insensitive
# c) bool-typed parameters can be specified by 1/0, true/false, yes/no and on/off
# d) prefix of input files is path_of_executable/input/
# e) ParSeries is a series of parameters concatenated by '$', e.g., "s40rts$0.2"



# ================================== Type of Nu ==================================
# WHAT: Top-level type of Nu field
# TYPE: constant / empirical / wisdom
# NOTE: Use "constant" with NU_CONST = 2 for 1D and 2D models.
NU_TYPE                                     empirical

# WHAT: whether to use fftw "lucky" numbers
# TYPE: bool
# NOTE: FFTW is best at handling logical sizes of the form 2^a 3^b 5^c 7^d 11^e 13^f, 
#       where e+f is either 0 or 1, and the other exponents are arbitrary.
#       We call numbers of this form lucky numbers.
#       http://www.fftw.org/fftw2_doc/fftw_3.html
NU_FFTW_LUCKY_NUMBER                        true



# =================================== constant ===================================
# WHAT: the constant value to be used when NU_TYPE = constant
# TYPE: integer
# NOTE: TWO is necessary and sufficient for 1D and 2D simulations.
NU_CONST                                    2



# =================================== empirical ==================================
# use an empirical equation to determine Nu(s,z) 
# Eqn. (69) in Kuangdai et al., Geophys. J. Int. (2016), Efficient global wave...  
# This empirical equation proves efficient and robust for global tomographic models.

# WHAT: basic reference value
# TYPE: integer
# NOTE: increase/decrease this for better accuracy/performance
NU_EMP_REF                                  48

# WHAT: global minimum value of Nu(s,z) 
# TYPE: integer
# NOTE: 1/3~1/2 of NU_EMP_REF is a reasonable choice
NU_EMP_MIN                                  16

# WHAT: scale NU_EMP_REF by s-coordinate, i.e., distance to axis
# TYPE: on-off [bool] and parameters [real]
# NOTE: Fs = (s / R0) ^ NU_EMP_POW_AXIS
NU_EMP_SCALE_AXIS                           true
NU_EMP_POW_AXIS                             1.0

# WHAT: scale NU_EMP_REF by epicentral distance (theta)
# TYPE: on-off [bool] and parameters [real]
# NOTE: F_theta = 1. + (NU_EMP_FACTOR_PI - 1.) * 
#                      pow((theta - NU_EMP_THETA_START) / (pi - NU_EMP_THETA_START), NU_EMP_POW_THETA)
NU_EMP_SCALE_THETA                          true
NU_EMP_POW_THETA                            3.0
NU_EMP_FACTOR_PI                            6.0
NU_EMP_THETA_START                          0.0

# WHAT: scale NU_EMP_REF by depth (km) to enhance surface wave resolution
# TYPE: on-off [bool] and parameters [real]
# NOTE: depth = 0 (surface)           => Fd = NU_EMP_FACTOR_SURF
#       depth = NU_EMP_DEPHT_START    => Fd = NU_EMP_FACTOR_SURF
#       depth = NU_EMP_DEPTH_END      => Fd = 1.0 
NU_EMP_SCALE_DEPTH                          true
NU_EMP_FACTOR_SURF                          5.0
NU_EMP_DEPTH_START                          300.0
NU_EMP_DEPTH_END                            600.0



# ================================== wisdom ==================================
# Q: What is Wisdom? 
# A: AxiSEM3D tries to learn the optimized Nu(s,z)  in the next simulation
#    and dump the results into a file, which can then be used repeatedly
#    in simulations with a similar scenario. Such a file is called a Wisdom,
#    a name borrowed form FFTW.
# Q: How to make a Wisdom?
# A: Learn a Wisdom by setting NU_WISDOM_LEARN true. The starting Nu(s,z)  field, 
#    Nu_start(s, z), can be either constant, empirical, or an existent Wisdom.   
#    The learnd Nu(s,z)  field is always SMALLER than Nu_start(s, z). 
# Q: How to use a Wisdom?
# A: To use a Wisdom, set NU_TYPE to "wisdom", and specifying the Wisdom file
#    in NU_WISDOM_REUSE_INPUT. One may adjust it by changing NU_WISDOM_REUSE_FACTOR.
#    Best practice: learn at some low frequency and reuse at higher frequencies.
#    You may NOT reuse a Wisdom if one of the following parameters significantly changes:
#    a) 3D model, either volumetric or geometric
#    b) source location and depth
#    c) total record length

# WHAT: on-off for learning
# TYPE: bool
# NOTE: Wisdom learning slows down the simulation, but does not affect results. 
NU_WISDOM_LEARN                             false

# WHAT: balance accuracy/performance of the learned Wisdom
# TYPE: accurate / balance / fast
# NOTE: here the accuracy and performance are relavent to subsequent simulations
#       using the learned Wisdom, not the learning process
NU_WISDOM_LEARN_AIM                         balance   

# WHAT: interval for Wisdom learning
# TYPE: integer
# NOTE: a value from 10 to 200 is suggested
NU_WISDOM_LEARN_INTERVAL                    100 

# WHAT: a file to save the learned Wisdom
# TYPE: string (path to file)
# NOTE: format of each row -- s, z, learned_nu, starting_nu
NU_WISDOM_LEARN_OUTPUT                      name.nu_wisdom

# WHAT: a Wisdom file that will be used in the next simulation
# TYPE: string (path to file)
# NOTE: A Wisdom can be applied to a mesh different from the one
#       with which it was learned 
NU_WISDOM_REUSE_INPUT                       name.nu_wisdom

# WHAT: a factor multiplied to Nu(s,z)  specified in NU_WISDOM_REUSE_INPUT
# TYPE: real
# NOTE: adjust a Wisdom before using it. For example, a Wisdom learned with 
#       s20rts can be safely applied to a simulation with s40rts by setting 
#       NU_WISDOM_REUSE_FACTOR = 1.5
NU_WISDOM_REUSE_FACTOR                      1.0


