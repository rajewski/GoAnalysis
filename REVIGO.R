#This script was generated form the REVIGO site by inputting a list of goterms for downregulated genes with their associated pvalue from the resultFisherWeightDown object in the GoEnrichemnt.R script.

# A plotting R script produced by the REVIGO server at http://revigo.irb.hr/
# If you found REVIGO useful in your work, please cite the following reference:
# Supek F et al. "REVIGO summarizes and visualizes long lists of Gene Ontology
# terms" PLoS ONE 2011. doi:10.1371/journal.pone.0021800


# --------------------------------------------------------------------------
# If you don't have the ggplot2 package installed, uncomment the following line:
# install.packages( "ggplot2" );
library( ggplot2 );
# --------------------------------------------------------------------------
# If you don't have the scales package installed, uncomment the following line:
# install.packages( "scales" );
library( scales );


# --------------------------------------------------------------------------
# Here is your data from REVIGO. Scroll down for plot configuration options.

revigo.names <- c("term_ID","description","frequency_%","plot_X","plot_Y","plot_size","log10_p_value","uniqueness","dispensability");
revigo.data <- rbind(c("GO:0002252","immune effector process", 0.185,-3.195,-0.012, 4.375,-0.6390,0.987,0.000),
c("GO:0007160","cell-matrix adhesion", 0.051,-6.014, 1.069, 3.817,-0.4271,0.994,0.000),
c("GO:0007623","circadian rhythm", 0.057,-1.997, 2.711, 3.862,-0.6308,0.994,0.000),
c("GO:0009651","response to salt stress", 0.043,-6.524,-3.347, 3.741,-5.5901,0.866,0.000),
c("GO:0015979","photosynthesis", 0.183,-4.673, 1.979, 4.370,-14.7167,0.949,0.000),
c("GO:0044699","single-organism process",46.569,-6.866, 1.281, 6.776,-0.5544,0.997,0.000),
c("GO:0045851","pH reduction", 0.015,-3.638,-7.118, 3.285,-2.5730,0.935,0.000),
c("GO:0051179","localization",18.495,-0.231, 1.349, 6.375,-0.9077,0.995,0.000),
c("GO:0010166","wax metabolic process", 0.002,-4.445, 3.545, 2.328,-1.1893,0.987,0.008),
c("GO:0032259","methylation", 3.103,-6.239, 2.636, 5.600,-2.5693,0.981,0.014),
c("GO:0007017","microtubule-based process", 0.658, 5.799,-0.105, 4.927,-8.4437,0.852,0.029),
c("GO:0071555","cell wall organization", 0.709, 1.981, 6.343, 4.959,-7.6126,0.838,0.033),
c("GO:0071554","cell wall organization or biogenesis", 0.950, 1.244, 3.045, 5.086,-0.6828,0.962,0.034),
c("GO:0009765","photosynthesis, light harvesting", 0.019,-5.084,-0.317, 3.393,-12.8761,0.917,0.040),
c("GO:0008216","spermidine metabolic process", 0.055, 2.427,-3.125, 3.852,-1.1893,0.897,0.043),
c("GO:0042744","hydrogen peroxide catabolic process", 0.093,-0.073, 0.024, 4.078,-3.8612,0.912,0.045),
c("GO:0018298","protein-chromophore linkage", 0.095, 0.210,-6.452, 4.084,-10.1965,0.922,0.045),
c("GO:0042537","benzene-containing compound metabolic process", 0.162, 2.229,-5.859, 4.317,-0.7355,0.922,0.047),
c("GO:0005975","carbohydrate metabolic process", 5.260,-2.284,-1.238, 5.829,-5.7696,0.948,0.058),
c("GO:0042633","hair cycle", 0.018,-0.889, 4.729, 3.373,-0.8748,0.869,0.060),
c("GO:0010143","cutin biosynthetic process", 0.002, 2.638,-8.637, 2.336,-4.0768,0.939,0.063),
c("GO:0010025","wax biosynthetic process", 0.002, 2.970, 4.457, 2.314,-0.6411,0.958,0.071),
c("GO:0006793","phosphorus metabolic process",13.507,-2.437, 1.492, 6.239,-3.2817,0.927,0.072),
c("GO:0006869","lipid transport", 0.270,-1.902, 5.825, 4.539,-7.4522,0.867,0.075),
c("GO:0006085","acetyl-CoA biosynthetic process", 0.111, 4.352,-2.014, 4.152,-3.6608,0.877,0.093),
c("GO:0044767","single-organism developmental process", 2.699, 5.042, 5.118, 5.539,-3.2431,0.814,0.095),
c("GO:0009813","flavonoid biosynthetic process", 0.016, 0.307,-2.103, 3.317,-2.4491,0.938,0.107),
c("GO:0090332","stomatal closure", 0.002, 3.777, 3.216, 2.365,-0.6902,0.898,0.117),
c("GO:0006629","lipid metabolic process", 3.522, 7.046, 1.715, 5.655,-1.7490,0.853,0.117),
c("GO:0009809","lignin biosynthetic process", 0.002, 5.405,-4.140, 2.423,-7.6799,0.841,0.118),
c("GO:0043412","macromolecule modification", 9.785,-1.581,-5.204, 6.099,-2.3112,0.937,0.121),
c("GO:0006775","fat-soluble vitamin metabolic process", 0.012, 8.184,-0.200, 3.203,-0.5465,0.871,0.127),
c("GO:0015977","carbon fixation", 0.036, 5.686, 3.841, 3.664,-1.0979,0.898,0.139),
c("GO:0006270","DNA replication initiation", 0.141, 4.597,-7.187, 4.259,-1.0545,0.877,0.150),
c("GO:0043603","cellular amide metabolic process", 6.879, 3.544,-6.596, 5.946,-1.0629,0.905,0.153),
c("GO:0016049","cell growth", 0.153, 6.661,-0.243, 4.294,-2.1925,0.839,0.162),
c("GO:0009820","alkaloid metabolic process", 0.006, 2.487,-0.946, 2.869,-0.9713,0.934,0.164),
c("GO:0009226","nucleotide-sugar biosynthetic process", 0.142, 4.801,-5.841, 4.260,-3.1493,0.851,0.170),
c("GO:0042127","regulation of cell proliferation", 0.313,-2.861,-7.581, 4.603,-0.6340,0.881,0.173),
c("GO:0044763","single-organism cellular process",27.536, 6.402, 3.341, 6.548,-1.0139,0.872,0.176),
c("GO:1902749","regulation of cell cycle G2/M phase transition", 0.041,-0.962,-8.013, 3.716,-0.6289,0.839,0.200),
c("GO:0030244","cellulose biosynthetic process", 0.025, 6.238,-5.568, 3.511,-7.3363,0.763,0.207),
c("GO:0009735","response to cytokinin", 0.012,-5.946,-3.315, 3.194,-4.9706,0.881,0.220),
c("GO:0006888","ER to Golgi vesicle-mediated transport", 0.125,-2.263, 5.976, 4.204,-1.0874,0.946,0.227),
c("GO:0002181","cytoplasmic translation", 0.064, 3.075,-7.028, 3.915,-1.0763,0.862,0.233),
c("GO:0042886","amide transport", 0.337,-2.984, 5.099, 4.636,-0.7912,0.951,0.246),
c("GO:0009200","deoxyribonucleoside triphosphate metabolic process", 0.112, 6.400,-2.440, 4.158,-2.3784,0.770,0.255),
c("GO:0006508","proteolysis", 5.223,-0.230,-6.100, 5.826,-0.6438,0.923,0.278),
c("GO:0016192","vesicle-mediated transport", 1.085,-2.810, 5.556, 5.144,-0.7542,0.948,0.280),
c("GO:0007264","small GTPase mediated signal transduction", 0.485,-4.650,-5.198, 4.794,-2.3408,0.791,0.282),
c("GO:1903507","negative regulation of nucleic acid-templated transcription", 0.609, 1.274,-7.144, 4.893,-1.0404,0.816,0.283),
c("GO:0006633","fatty acid biosynthetic process", 0.617, 6.561,-2.929, 4.899,-4.8894,0.713,0.296),
c("GO:0006730","one-carbon metabolic process", 0.328, 7.467,-0.997, 4.625,-1.1844,0.809,0.297),
c("GO:0055114","oxidation-reduction process",15.060, 7.169, 1.156, 6.286,-4.5302,0.841,0.300),
c("GO:0043622","cortical microtubule organization", 0.002, 2.870, 6.016, 2.446,-1.7703,0.841,0.310),
c("GO:0009607","response to biotic stimulus", 0.342,-6.491,-2.573, 4.643,-0.9571,0.904,0.335),
c("GO:0043543","protein acylation", 0.202, 0.427,-6.429, 4.413,-0.6278,0.918,0.359),
c("GO:0006558","L-phenylalanine metabolic process", 0.075, 6.619,-3.442, 3.984,-2.3355,0.788,0.360),
c("GO:0009900","dehiscence", 0.001, 0.070, 4.804, 2.090,-0.8058,0.880,0.362),
c("GO:0006427","histidyl-tRNA aminoacylation", 0.043, 4.649,-4.797, 3.738,-0.8748,0.777,0.364),
c("GO:0006108","malate metabolic process", 0.088, 7.611,-1.713, 4.051,-2.3240,0.808,0.365),
c("GO:0006833","water transport", 0.014,-3.436, 5.295, 3.256,-2.8613,0.896,0.365),
c("GO:0050832","defense response to fungus", 0.028,-6.534,-3.064, 3.557,-3.7655,0.880,0.369),
c("GO:0006002","fructose 6-phosphate metabolic process", 0.060, 3.721, 0.761, 3.885,-0.8058,0.884,0.370),
c("GO:0010628","positive regulation of gene expression", 0.653,-1.907,-7.653, 4.923,-0.4896,0.896,0.374),
c("GO:0031640","killing of cells of other organism", 0.019,-3.607,-6.814, 3.389,-2.1200,0.933,0.376),
c("GO:0044711","single-organism biosynthetic process",10.864, 7.056,-2.243, 6.144,-0.5619,0.830,0.382),
c("GO:0060359","response to ammonium ion", 0.019,-5.889,-3.056, 3.382,-0.8748,0.891,0.384),
c("GO:1900407","regulation of cellular response to oxidative stress", 0.014,-5.242,-4.647, 3.267,-0.8058,0.826,0.388),
c("GO:0042256","mature ribosome assembly", 0.051, 1.765, 6.276, 3.819,-6.0264,0.881,0.389),
c("GO:0046883","regulation of hormone secretion", 0.040,-2.985,-4.759, 3.709,-0.7403,0.778,0.399));

one.data <- data.frame(revigo.data);
names(one.data) <- revigo.names;
one.data <- one.data [(one.data$plot_X != "null" & one.data$plot_Y != "null"), ];
one.data$plot_X <- as.numeric( as.character(one.data$plot_X) );
one.data$plot_Y <- as.numeric( as.character(one.data$plot_Y) );
one.data$plot_size <- as.numeric( as.character(one.data$plot_size) );
one.data$log10_p_value <- as.numeric( as.character(one.data$log10_p_value) );
one.data$frequency <- as.numeric( as.character(one.data$frequency) );
one.data$uniqueness <- as.numeric( as.character(one.data$uniqueness) );
one.data$dispensability <- as.numeric( as.character(one.data$dispensability) );
#head(one.data);


# --------------------------------------------------------------------------
# Names of the axes, sizes of the numbers and letters, names of the columns,
# etc. can be changed below

p1 <- ggplot( data = one.data );
p1 <- p1 + geom_point( aes( plot_X, plot_Y, colour = log10_p_value, size = plot_size), alpha = I(0.6) ) + scale_size_area();
p1 <- p1 + scale_colour_gradientn( colours = c("blue", "green", "yellow", "red"), limits = c( min(one.data$log10_p_value), 0) );
p1 <- p1 + geom_point( aes(plot_X, plot_Y, size = plot_size), shape = 21, fill = "transparent", colour = I (alpha ("black", 0.6) )) + scale_size_area();
p1 <- p1 + scale_size( range=c(5, 30)) + theme_bw(); # + scale_fill_gradientn(colours = heat_hcl(7), limits = c(-300, 0) );
ex <- one.data [ one.data$dispensability < 0.15, ]; 
p1 <- p1 + geom_text( data = ex, aes(plot_X, plot_Y, label = description), colour = I(alpha("black", 0.85)), size = 3 );
p1 <- p1 + labs (y = "semantic space x", x = "semantic space y");
p1 <- p1 + theme(legend.key = element_blank()) ;
one.x_range = max(one.data$plot_X) - min(one.data$plot_X);
one.y_range = max(one.data$plot_Y) - min(one.data$plot_Y);
p1 <- p1 + xlim(min(one.data$plot_X)-one.x_range/10,max(one.data$plot_X)+one.x_range/10);
p1 <- p1 + ylim(min(one.data$plot_Y)-one.y_range/10,max(one.data$plot_Y)+one.y_range/10);



# --------------------------------------------------------------------------
# Output the plot to screen

p1;

# Uncomment the line below to also save the plot to a file.
# The file type depends on the extension (default=pdf).

# ggsave("C:/Users/path_to_your_file/revigo-plot.pdf");
