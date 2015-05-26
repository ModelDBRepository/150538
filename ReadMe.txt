This is the readme for the model associated with the paper

X. Li, K. Morita, H. P. C. Robinson and M. Small (2013) Control of
layer 5 pyramidal cell spiking by oscillatory inhibition in the distal
apical dendrites: a computational modelling study. J Neurophysiol.


General description of the model:

This model examined how distal oscillatory inhibition influences the
firing of a biophysically-detailed layer 5 pyramidal neuron model.


Running the file "mainfile_stim_cyc.hoc" will start the simulation
with the most typical configuration. Compile the mod files first with
mknrndll (MAC and mswin) if starting manually.


Description of key files:

"j4a.hoc" defines the model of a layer 5 pyramidal neuron from the
paper of Mainen Nature 1996.

The other hoc files define different distributions of GLUT and GABA
synapses over the soma, basal and distal dendrites.

The Matlab files i.e. "makestim_GABAgamma_stim.m" are used to generate
the oscillatory inhibitory inputs at different frequencies.

20150525 Update from Ted Carnevale: Fixed ca initialization by
inserting cai = ca into INITIAL block.  Changed integration method
from euler to derivimplicit which is appropriate for simple ion
accumulation mechanisms.  See Integration methods for SOLVE statements
http://www.neuron.yale.edu/phpBB/viewtopic.php?f=28&t=592
