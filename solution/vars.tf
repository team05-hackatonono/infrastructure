variable "availability_zone_names" {
 type = map
 default = [{ us_east_2: "us-east-2",
 },
 {
 us_central: "us-central",
 },
{
 bra_south: "bra-south"
}]
}
