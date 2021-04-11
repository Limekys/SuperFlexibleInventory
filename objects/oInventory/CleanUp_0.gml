if ds_exists(inv_item, ds_type_grid)
ds_grid_destroy(inv_item);

if surface_exists(inv_surf)
surface_free(inv_surf);

//surface_free(enchant_surf);