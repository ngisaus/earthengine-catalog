local id = 'JRC/GHSL/P2023A/GHS_SMOD';
local predecessor_id = 'JRC/GHSL/P2016/SMOD_POP_GLOBE_V1';
local subdir = 'JRC';

local ee_const = import 'earthengine_const.libsonnet';
local ee = import 'earthengine.libsonnet';
local spdx = import 'spdx.libsonnet';

local license = spdx.proprietary;

local basename = std.strReplace(id, '/', '_');
local base_filename = basename + '.json';
local predecessor_basename = std.strReplace(predecessor_id, '/', '_');
local predecessor_filename = predecessor_basename + '.json';
local self_ee_catalog_url = ee_const.ee_catalog_url + basename;
local catalog_subdir_url = ee_const.catalog_base + subdir + '/';
local predecessor_url = catalog_subdir_url + predecessor_filename;

{
  stac_version: ee_const.stac_version,
  type: ee_const.stac_type.collection,
  stac_extensions: [
    ee_const.ext_eo,
    ee_const.ext_sci,
    ee_const.ext_ver,
  ],
  id: id,
  title: 'GHS-SMOD R2023A - Global Human Settlement Layers (1975-2030)',
  version: 'v1',
  'gee:type': ee_const.gee_type.image_collection,
  description: |||
    The GHS-SMOD dataset is the rural-urban Settlement classification MODel adopted by
    the GHSL. It is the representation of the degree of urbanization
    ([DEGURBA](https://ec.europa.eu/eurostat/web/degree-of-urbanisation/background))
    concept in the GHSL data scenario. Each grid in the GHS-SMOD has been
    generated by integrating the GHSL built-up areas and GHSL population grids
    data for reference epochs: 1975, 1990, 2000, 2015, 2020, 2025, 2030.

    The DEGURBA classification schema is a people-based definition of cities and
    settlements: it operates using as main input a 1 km^2 grid cell accounting
    for population at a given point in time. The DEGURBA discriminates the
    population grid cells in three main classes: '[urban centers](https://ec.europa.eu/eurostat/statistics-explained/index.php/Glossary:Urban_centre)'
    (cities), '[urban clusters](https://ec.europa.eu/eurostat/statistics-explained/index.php/Glossary:Urban_cluster)'
    (towns and suburbs), and '[rural grid cells](https://ec.europa.eu/eurostat/statistics-explained/index.php/Glossary:Rural_grid_cell)'.
    (base). These class abstractions translate to 'high density clusters (HDC)',
    'low density clusters (LDC)', and 'rural grid cells (RUR)', respectively,
    in the GHS-SMOD implementation.

    The 'HDC' differ from the DEGURBA '[urban centers](https://ec.europa.eu/eurostat/statistics-explained/index.php/Glossary:Urban_centre)'
    in that they account for the over-fragmentation of cities in regions
    with large low-density residential development by integrating the
    built-up layer. In the GHS-SMOD representation, the 'HDC' are the spatial
    generalization of contiguous population grid cells (4-connectivity,
    gap-filling) with a density of at least 1500 inhabitants per km^2 or a
    density of built-up surface > 50%, and a minimum total resident population
    of 50000. The 'LDC' are continuous grid cells with a density of at least 300
    inhabitants per km^2 and a minimum total population of 5000. The 'RUR' are
    grid cells outside 'HDC' and 'LDC' with population > 0 and < 300. Everything
    else is classified as inhabited areas where population = 0.

    The Global Human Settlement Layer (GHSL) project is supported by the
    European Commission, Joint Research Center, and Directorate-General for
    Regional and Urban Policy.
  |||,
  license: license.id,
  links: ee.standardLinks(subdir, id) + [
    ee.link.predecessor(predecessor_id, predecessor_url)
  ],
  keywords: [
    'ghsl',
    'jrc',
    'settlement',
    'smod',
  ],
  providers: [
    ee.producer_provider('EC JRC', 'https://ghsl.jrc.ec.europa.eu/ghs_smod2023.php'),
    ee.host_provider(self_ee_catalog_url),
  ],
  extent: ee.extent_global('1975-01-01T00:00:00Z', '2030-12-31T00:00:00Z'),
  summaries: {
    gsd: [
      1000.0,
    ],
    'eo:bands': [
      {
        name: 'smod_code',
        description: 'Degree of urbanization',
        'gee:classes': [
          {
            color: '000000',
            description: 'Inhabited areas',
            value: 0,
          },
          {
            value: 1,
            color: '448564',
            description: 'RUR (rural grid cells)',
          },
          {
            value: 2,
            color: '70daa4',
            description: 'LDC (low density clusters)',
          },
          {
            value: 3,
            color: 'ffffff',
            description: 'HDC (high density clusters)',
          },
        ],
      },
    ],
    'gee:visualizations': [
      {
        display_name: 'Degree of Urbanization',
        lookat: {
          lat: 31.13,
          lon: 114.96,
          zoom: 4,
        },
        image_visualization: {
          band_vis: {
            min: [
              0.0,
            ],
            max: [
              3.0,
            ],
            palette: [
              '000000',
              '448564',
              '70daa4',
              'ffffff',
            ],
            bands: [
              'smod_code',
            ],
          },
        },
      },
    ],
  },
  'sci:citation': |||
    Schiavina M., Melchiorri M., Pesaresi M. (2023):
    GHS-SMOD R2023A - GHS settlement layers, application of the Degree of
    Urbanisation methodology (stage I) to GHS-POP R2023A and GHS-BUILT-S R2023A,
    multitemporal (1975-2030)European Commission, Joint Research Centre (JRC)
    PID: http://data.europa.eu/89h/a0df7a6f-49de-46ea-9bde-563437a6e2ba,
    [doi:10.2905/A0DF7A6F-49DE-46EA-9BDE-563437A6E2BA](https://doi.org/10.2905/A0DF7A6F-49DE-46EA-9BDE-563437A6E2BA)
  |||,
  'sci:doi': '10.2905/A0DF7A6F-49DE-46EA-9BDE-563437A6E2BA',
  'gee:terms_of_use': |||
    The GHSL has been produced by the EC JRC as open and free data. Reuse is
    authorised, provided the source is acknowledged. For more information,
    please read the use conditions ([European Commission Reuse and Copyright
    Notice](https://ec.europa.eu/info/legal-notice_en)).
  |||,
}