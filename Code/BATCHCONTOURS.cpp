#include <iostream>
#include <fstream>
#include <iomanip>
#include <vector>
#include <string>
#include <cmath>
#include <algorithm>
using namespace std ;
#include "Tools.h"
#include "Material.h"
#include "Contact_Law.h"
#include "Node.h"
#include "Gauss.h"
#include "Border.h"
#include "Contact_Element.h"
#include "Body.h"
#include "Spy.h"
#include "IO.h"
#include "Solver.h"
#include "Proximity.h"
#include "Graphic.h"
#include "Monitoring.h"

int main(int argc, char **argv)
{
    // CREATE VARIABLES //
    string Simulation_name ;
    int Nb_materials ;
    vector<Material> Materials ;
    int Nb_contact_laws ;
    vector<Contact_law> Contact_laws ;
    string Solver ;
    double Tini, Deltat, Tend, Time ;
    double Target_error, Inv_Target_error, Control_parameter, Accepted_ratio ;
    double Max_mass_scaling, Control_parameter_mass_scaling, Error_factor_mass_scaling, Decrease_factor_mass_scaling ;
    double Save_period, Print_period, Contact_update_period ;
    double Next_save, Next_print, Next_contact_update ;
    int Number_save, Number_print, Number_iteration ;
    double Xmin_period, Xmax_period, Penalty ;
    double Xgravity, Ygravity ;
    double Chains_typical_pressure, Chains_size_ratio, Chains_enable ;
    double Fields_xmin, Fields_xmax, Fields_ymin, Fields_ymax, Fields_step, Fields_dist ,Fields_enable;
    int Nb_bodies ;
    vector<Body> Bodies ;
    int Nb_monitored ;
    vector<vector<double>> Monitored ;
    int Nb_deactivated ;
    vector<vector<double>> Deactivated ;
    int Nb_spies ;
    vector<Spy> Spies ;
    int Nb_regions = 0 ;
    vector<vector<int>> Regions ;
    vector<int> flags(12) ;
    //int flag_failure = 0 ;
    vector<int> To_Plot(44) ;
    vector<vector<int>> Contacts_Table ;

    // LOAD STATIC DATA //
    Load_static( Simulation_name, Nb_materials, Materials,
                 Nb_contact_laws, Contact_laws, Contacts_Table,
                 Solver, Tini,	Deltat, Tend,
                 Target_error, Inv_Target_error, Control_parameter, Accepted_ratio,
                 Max_mass_scaling, Control_parameter_mass_scaling, Error_factor_mass_scaling, Decrease_factor_mass_scaling,
                 Save_period, Print_period, Contact_update_period,
                 Xmin_period, Xmax_period, Penalty, Xgravity, Ygravity,
                 Chains_typical_pressure, Chains_size_ratio,Chains_enable,
                 Fields_xmin, Fields_xmax, Fields_ymin, Fields_ymax, Fields_step, Fields_dist,Fields_enable,
                 Nb_monitored, Monitored, Nb_deactivated, Deactivated, Nb_spies, Spies,
                 Nb_regions, Regions, Nb_bodies, Bodies, To_Plot ) ;

    int istart = atoi(argv[1]) ;
    int interval = atoi(argv[2]) ;
    int iend = atoi(argv[3]) ;

    for (int i(istart) ; i<=iend ; i+=interval)
    {
        Number_save = i ;
        for (int j=0 ; j<(int)flags.size() ; j++)
            flags[j] = 0 ;
        flags[7] = 1 ;
        Load_dynamic( Number_save, Number_print,
                      Time, Number_iteration, Deltat, Solver,
                      Next_save,	Next_print, Next_contact_update,
                      Xmin_period, Xmax_period,
                      Bodies, flags ) ;
        Number_print = i ;
        Write_contours(Nb_bodies, Bodies, Number_iteration, Number_save, Number_print, Time, Xmin_period, Xmax_period) ;
    }
}
