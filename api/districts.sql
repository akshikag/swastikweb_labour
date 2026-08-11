--
-- PostgreSQL database dump
--

\restrict KIAXbYlOamsDaN6T5BxH8Wrmm2Kl6qCSTNMtgeTvGyMK24JaiUoMhG4VjzwNmnc

-- Dumped from database version 16.10
-- Dumped by pg_dump version 17.6

-- Started on 2025-11-28 14:08:13

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 240 (class 1259 OID 31500)
-- Name: districts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.districts (
    id integer NOT NULL,
    state_id bigint,
    lgd_code bigint,
    district_name character varying(100),
    created timestamp without time zone,
    modified timestamp without time zone
);


ALTER TABLE public.districts OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 31503)
-- Name: districts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.districts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.districts_id_seq OWNER TO postgres;

--
-- TOC entry 4966 (class 0 OID 0)
-- Dependencies: 241
-- Name: districts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.districts_id_seq OWNED BY public.districts.id;


--
-- TOC entry 4813 (class 2604 OID 31504)
-- Name: districts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.districts ALTER COLUMN id SET DEFAULT nextval('public.districts_id_seq'::regclass);


--
-- TOC entry 4959 (class 0 OID 31500)
-- Dependencies: 240
-- Data for Name: districts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.districts VALUES (1, 35, 603, 'Nicobars', NULL, NULL);
INSERT INTO public.districts VALUES (2, 35, 632, 'North And Middle Andaman', NULL, NULL);
INSERT INTO public.districts VALUES (3, 35, 602, 'South Andamans', NULL, NULL);
INSERT INTO public.districts VALUES (4, 28, 745, 'Alluri Sitharama Raju', NULL, NULL);
INSERT INTO public.districts VALUES (5, 28, 744, 'Anakapalli', NULL, NULL);
INSERT INTO public.districts VALUES (6, 28, 502, 'Ananthapuramu', NULL, NULL);
INSERT INTO public.districts VALUES (7, 28, 753, 'Annamayya', NULL, NULL);
INSERT INTO public.districts VALUES (8, 28, 750, 'Bapatla', NULL, NULL);
INSERT INTO public.districts VALUES (9, 28, 503, 'Chittoor', NULL, NULL);
INSERT INTO public.districts VALUES (10, 28, 747, 'Dr. B.R. Ambedkar Konaseema', NULL, NULL);
INSERT INTO public.districts VALUES (11, 28, 505, 'East Godavari', NULL, NULL);
INSERT INTO public.districts VALUES (12, 28, 748, 'Eluru', NULL, NULL);
INSERT INTO public.districts VALUES (13, 28, 506, 'Guntur', NULL, NULL);
INSERT INTO public.districts VALUES (14, 28, 746, 'Kakinada', NULL, NULL);
INSERT INTO public.districts VALUES (15, 28, 510, 'Krishna', NULL, NULL);
INSERT INTO public.districts VALUES (16, 28, 511, 'Kurnool', NULL, NULL);
INSERT INTO public.districts VALUES (17, 28, 755, 'Nandyal', NULL, NULL);
INSERT INTO public.districts VALUES (18, 28, 749, 'Ntr', NULL, NULL);
INSERT INTO public.districts VALUES (19, 28, 751, 'Palnadu', NULL, NULL);
INSERT INTO public.districts VALUES (20, 28, 743, 'Parvathipuram Manyam', NULL, NULL);
INSERT INTO public.districts VALUES (21, 28, 517, 'Prakasam', NULL, NULL);
INSERT INTO public.districts VALUES (22, 28, 519, 'Srikakulam', NULL, NULL);
INSERT INTO public.districts VALUES (23, 28, 515, 'Sri Potti Sriramulu Nellore', NULL, NULL);
INSERT INTO public.districts VALUES (24, 28, 754, 'Sri Sathya Sai', NULL, NULL);
INSERT INTO public.districts VALUES (25, 28, 752, 'Tirupati', NULL, NULL);
INSERT INTO public.districts VALUES (26, 28, 520, 'Visakhapatnam', NULL, NULL);
INSERT INTO public.districts VALUES (27, 28, 521, 'Vizianagaram', NULL, NULL);
INSERT INTO public.districts VALUES (28, 28, 523, 'West Godavari', NULL, NULL);
INSERT INTO public.districts VALUES (29, 28, 504, 'Y.S.R.', NULL, NULL);
INSERT INTO public.districts VALUES (30, 12, 628, 'Anjaw', NULL, NULL);
INSERT INTO public.districts VALUES (31, 12, 229, 'Changlang', NULL, NULL);
INSERT INTO public.districts VALUES (32, 12, 230, 'Dibang Valley', NULL, NULL);
INSERT INTO public.districts VALUES (33, 12, 231, 'East Kameng', NULL, NULL);
INSERT INTO public.districts VALUES (34, 12, 232, 'East Siang', NULL, NULL);
INSERT INTO public.districts VALUES (35, 12, 718, 'Kamle', NULL, NULL);
INSERT INTO public.districts VALUES (36, 12, 677, 'Kra Daadi', NULL, NULL);
INSERT INTO public.districts VALUES (37, 12, 233, 'Kurung Kumey', NULL, NULL);
INSERT INTO public.districts VALUES (38, 12, 724, 'Leparada', NULL, NULL);
INSERT INTO public.districts VALUES (39, 12, 234, 'Lohit', NULL, NULL);
INSERT INTO public.districts VALUES (40, 12, 666, 'Longding', NULL, NULL);
INSERT INTO public.districts VALUES (41, 12, 235, 'Lower Dibang Valley', NULL, NULL);
INSERT INTO public.districts VALUES (42, 12, 719, 'Lower Siang', NULL, NULL);
INSERT INTO public.districts VALUES (43, 12, 236, 'Lower Subansiri', NULL, NULL);
INSERT INTO public.districts VALUES (44, 12, 678, 'Namsai', NULL, NULL);
INSERT INTO public.districts VALUES (45, 12, 723, 'Pakke Kessang', NULL, NULL);
INSERT INTO public.districts VALUES (46, 12, 237, 'Papum Pare', NULL, NULL);
INSERT INTO public.districts VALUES (47, 12, 725, 'Shi Yomi', NULL, NULL);
INSERT INTO public.districts VALUES (48, 12, 679, 'Siang', NULL, NULL);
INSERT INTO public.districts VALUES (49, 12, 238, 'Tawang', NULL, NULL);
INSERT INTO public.districts VALUES (50, 12, 239, 'Tirap', NULL, NULL);
INSERT INTO public.districts VALUES (51, 12, 240, 'Upper Siang', NULL, NULL);
INSERT INTO public.districts VALUES (52, 12, 241, 'Upper Subansiri', NULL, NULL);
INSERT INTO public.districts VALUES (53, 12, 242, 'West Kameng', NULL, NULL);
INSERT INTO public.districts VALUES (54, 12, 243, 'West Siang', NULL, NULL);
INSERT INTO public.districts VALUES (55, 18, 739, 'Bajali', NULL, NULL);
INSERT INTO public.districts VALUES (56, 18, 616, 'Baksa', NULL, NULL);
INSERT INTO public.districts VALUES (57, 18, 280, 'Barpeta', NULL, NULL);
INSERT INTO public.districts VALUES (58, 18, 705, 'Biswanath', NULL, NULL);
INSERT INTO public.districts VALUES (59, 18, 281, 'Bongaigaon', NULL, NULL);
INSERT INTO public.districts VALUES (60, 18, 282, 'Cachar', NULL, NULL);
INSERT INTO public.districts VALUES (61, 18, 708, 'Charaideo', NULL, NULL);
INSERT INTO public.districts VALUES (62, 18, 612, 'Chirang', NULL, NULL);
INSERT INTO public.districts VALUES (63, 18, 283, 'Darrang', NULL, NULL);
INSERT INTO public.districts VALUES (64, 18, 284, 'Dhemaji', NULL, NULL);
INSERT INTO public.districts VALUES (65, 18, 285, 'Dhubri', NULL, NULL);
INSERT INTO public.districts VALUES (66, 18, 286, 'Dibrugarh', NULL, NULL);
INSERT INTO public.districts VALUES (67, 18, 299, 'Dima Hasao', NULL, NULL);
INSERT INTO public.districts VALUES (68, 18, 287, 'Goalpara', NULL, NULL);
INSERT INTO public.districts VALUES (69, 18, 288, 'Golaghat', NULL, NULL);
INSERT INTO public.districts VALUES (70, 18, 289, 'Hailakandi', NULL, NULL);
INSERT INTO public.districts VALUES (71, 18, 709, 'Hojai', NULL, NULL);
INSERT INTO public.districts VALUES (72, 18, 290, 'Jorhat', NULL, NULL);
INSERT INTO public.districts VALUES (73, 18, 291, 'Kamrup', NULL, NULL);
INSERT INTO public.districts VALUES (74, 18, 618, 'Kamrup Metro', NULL, NULL);
INSERT INTO public.districts VALUES (75, 18, 292, 'Karbi Anglong', NULL, NULL);
INSERT INTO public.districts VALUES (76, 18, 293, 'Karimganj', NULL, NULL);
INSERT INTO public.districts VALUES (77, 18, 294, 'Kokrajhar', NULL, NULL);
INSERT INTO public.districts VALUES (78, 18, 295, 'Lakhimpur', NULL, NULL);
INSERT INTO public.districts VALUES (79, 18, 706, 'Majuli', NULL, NULL);
INSERT INTO public.districts VALUES (80, 18, 296, 'Marigaon', NULL, NULL);
INSERT INTO public.districts VALUES (81, 18, 297, 'Nagaon', NULL, NULL);
INSERT INTO public.districts VALUES (82, 18, 298, 'Nalbari', NULL, NULL);
INSERT INTO public.districts VALUES (83, 18, 300, 'Sivasagar', NULL, NULL);
INSERT INTO public.districts VALUES (84, 18, 301, 'Sonitpur', NULL, NULL);
INSERT INTO public.districts VALUES (85, 18, 707, 'South Salmara Mancachar', NULL, NULL);
INSERT INTO public.districts VALUES (86, 18, 756, 'Tamulpur', NULL, NULL);
INSERT INTO public.districts VALUES (87, 18, 302, 'Tinsukia', NULL, NULL);
INSERT INTO public.districts VALUES (88, 18, 617, 'Udalguri', NULL, NULL);
INSERT INTO public.districts VALUES (89, 18, 710, 'West Karbi Anglong', NULL, NULL);
INSERT INTO public.districts VALUES (90, 10, 188, 'Araria', NULL, NULL);
INSERT INTO public.districts VALUES (91, 10, 611, 'Arwal', NULL, NULL);
INSERT INTO public.districts VALUES (92, 10, 189, 'Aurangabad', NULL, NULL);
INSERT INTO public.districts VALUES (93, 10, 190, 'Banka', NULL, NULL);
INSERT INTO public.districts VALUES (94, 10, 191, 'Begusarai', NULL, NULL);
INSERT INTO public.districts VALUES (95, 10, 192, 'Bhagalpur', NULL, NULL);
INSERT INTO public.districts VALUES (96, 10, 193, 'Bhojpur', NULL, NULL);
INSERT INTO public.districts VALUES (97, 10, 194, 'Buxar', NULL, NULL);
INSERT INTO public.districts VALUES (98, 10, 195, 'Darbhanga', NULL, NULL);
INSERT INTO public.districts VALUES (99, 10, 196, 'Gaya', NULL, NULL);
INSERT INTO public.districts VALUES (100, 10, 197, 'Gopalganj', NULL, NULL);
INSERT INTO public.districts VALUES (101, 10, 198, 'Jamui', NULL, NULL);
INSERT INTO public.districts VALUES (102, 10, 199, 'Jehanabad', NULL, NULL);
INSERT INTO public.districts VALUES (103, 10, 200, 'Kaimur (Bhabua)', NULL, NULL);
INSERT INTO public.districts VALUES (104, 10, 201, 'Katihar', NULL, NULL);
INSERT INTO public.districts VALUES (105, 10, 202, 'Khagaria', NULL, NULL);
INSERT INTO public.districts VALUES (106, 10, 203, 'Kishanganj', NULL, NULL);
INSERT INTO public.districts VALUES (107, 10, 204, 'Lakhisarai', NULL, NULL);
INSERT INTO public.districts VALUES (108, 10, 205, 'Madhepura', NULL, NULL);
INSERT INTO public.districts VALUES (109, 10, 206, 'Madhubani', NULL, NULL);
INSERT INTO public.districts VALUES (110, 10, 207, 'Munger', NULL, NULL);
INSERT INTO public.districts VALUES (111, 10, 208, 'Muzaffarpur', NULL, NULL);
INSERT INTO public.districts VALUES (112, 10, 209, 'Nalanda', NULL, NULL);
INSERT INTO public.districts VALUES (113, 10, 210, 'Nawada', NULL, NULL);
INSERT INTO public.districts VALUES (114, 10, 211, 'Pashchim Champaran', NULL, NULL);
INSERT INTO public.districts VALUES (115, 10, 212, 'Patna', NULL, NULL);
INSERT INTO public.districts VALUES (116, 10, 213, 'Purbi Champaran', NULL, NULL);
INSERT INTO public.districts VALUES (117, 10, 214, 'Purnia', NULL, NULL);
INSERT INTO public.districts VALUES (118, 10, 215, 'Rohtas', NULL, NULL);
INSERT INTO public.districts VALUES (119, 10, 216, 'Saharsa', NULL, NULL);
INSERT INTO public.districts VALUES (120, 10, 217, 'Samastipur', NULL, NULL);
INSERT INTO public.districts VALUES (121, 10, 218, 'Saran', NULL, NULL);
INSERT INTO public.districts VALUES (122, 10, 219, 'Sheikhpura', NULL, NULL);
INSERT INTO public.districts VALUES (123, 10, 220, 'Sheohar', NULL, NULL);
INSERT INTO public.districts VALUES (124, 10, 221, 'Sitamarhi', NULL, NULL);
INSERT INTO public.districts VALUES (125, 10, 222, 'Siwan', NULL, NULL);
INSERT INTO public.districts VALUES (126, 10, 223, 'Supaul', NULL, NULL);
INSERT INTO public.districts VALUES (127, 10, 224, 'Vaishali', NULL, NULL);
INSERT INTO public.districts VALUES (128, 4, 44, 'Chandigarh', NULL, NULL);
INSERT INTO public.districts VALUES (129, 22, 646, 'Balod', NULL, NULL);
INSERT INTO public.districts VALUES (130, 22, 644, 'Balodabazar-Bhatapara', NULL, NULL);
INSERT INTO public.districts VALUES (131, 22, 649, 'Balrampur-Ramanujganj', NULL, NULL);
INSERT INTO public.districts VALUES (132, 22, 374, 'Bastar', NULL, NULL);
INSERT INTO public.districts VALUES (133, 22, 650, 'Bemetara', NULL, NULL);
INSERT INTO public.districts VALUES (134, 22, 636, 'Bijapur', NULL, NULL);
INSERT INTO public.districts VALUES (135, 22, 375, 'Bilaspur', NULL, NULL);
INSERT INTO public.districts VALUES (136, 22, 376, 'Dakshin Bastar Dantewada', NULL, NULL);
INSERT INTO public.districts VALUES (137, 22, 377, 'Dhamtari', NULL, NULL);
INSERT INTO public.districts VALUES (138, 22, 378, 'Durg', NULL, NULL);
INSERT INTO public.districts VALUES (139, 22, 645, 'Gariyaband', NULL, NULL);
INSERT INTO public.districts VALUES (140, 22, 734, 'Gaurela-Pendra-Marwahi', NULL, NULL);
INSERT INTO public.districts VALUES (141, 22, 379, 'Janjgir-Champa', NULL, NULL);
INSERT INTO public.districts VALUES (142, 22, 380, 'Jashpur', NULL, NULL);
INSERT INTO public.districts VALUES (143, 22, 382, 'Kabeerdham', NULL, NULL);
INSERT INTO public.districts VALUES (144, 22, 759, 'Khairagarh-Chhuikhadan-Gandai', NULL, NULL);
INSERT INTO public.districts VALUES (145, 22, 643, 'Kondagaon', NULL, NULL);
INSERT INTO public.districts VALUES (146, 22, 383, 'Korba', NULL, NULL);
INSERT INTO public.districts VALUES (147, 22, 384, 'Korea', NULL, NULL);
INSERT INTO public.districts VALUES (148, 22, 385, 'Mahasamund', NULL, NULL);
INSERT INTO public.districts VALUES (149, 22, 760, 'Manendragarh-Chirmiri-Bharatpur(M C B)', NULL, NULL);
INSERT INTO public.districts VALUES (150, 22, 761, 'Mohla-Manpur-Ambagarh Chouki', NULL, NULL);
INSERT INTO public.districts VALUES (151, 22, 647, 'Mungeli', NULL, NULL);
INSERT INTO public.districts VALUES (152, 22, 637, 'Narayanpur', NULL, NULL);
INSERT INTO public.districts VALUES (153, 22, 386, 'Raigarh', NULL, NULL);
INSERT INTO public.districts VALUES (154, 22, 387, 'Raipur', NULL, NULL);
INSERT INTO public.districts VALUES (155, 22, 388, 'Rajnandgaon', NULL, NULL);
INSERT INTO public.districts VALUES (156, 22, 762, 'Sakti', NULL, NULL);
INSERT INTO public.districts VALUES (157, 22, 763, 'Sarangarh-Bilaigarh', NULL, NULL);
INSERT INTO public.districts VALUES (158, 22, 642, 'Sukma', NULL, NULL);
INSERT INTO public.districts VALUES (159, 22, 648, 'Surajpur', NULL, NULL);
INSERT INTO public.districts VALUES (160, 22, 389, 'Surguja', NULL, NULL);
INSERT INTO public.districts VALUES (161, 22, 381, 'Uttar Bastar Kanker', NULL, NULL);
INSERT INTO public.districts VALUES (162, 7, 77, 'Central', NULL, NULL);
INSERT INTO public.districts VALUES (163, 7, 78, 'East', NULL, NULL);
INSERT INTO public.districts VALUES (164, 7, 79, 'New Delhi', NULL, NULL);
INSERT INTO public.districts VALUES (165, 7, 80, 'North', NULL, NULL);
INSERT INTO public.districts VALUES (166, 7, 81, 'North East', NULL, NULL);
INSERT INTO public.districts VALUES (167, 7, 82, 'North West', NULL, NULL);
INSERT INTO public.districts VALUES (168, 7, 671, 'Shahdara', NULL, NULL);
INSERT INTO public.districts VALUES (169, 7, 83, 'South', NULL, NULL);
INSERT INTO public.districts VALUES (170, 7, 670, 'South East', NULL, NULL);
INSERT INTO public.districts VALUES (171, 7, 84, 'South West', NULL, NULL);
INSERT INTO public.districts VALUES (172, 7, 85, 'West', NULL, NULL);
INSERT INTO public.districts VALUES (173, 30, 551, 'North Goa', NULL, NULL);
INSERT INTO public.districts VALUES (174, 30, 552, 'South Goa', NULL, NULL);
INSERT INTO public.districts VALUES (175, 24, 438, 'Ahmedabad', NULL, NULL);
INSERT INTO public.districts VALUES (176, 24, 439, 'Amreli', NULL, NULL);
INSERT INTO public.districts VALUES (177, 24, 440, 'Anand', NULL, NULL);
INSERT INTO public.districts VALUES (178, 24, 672, 'Arvalli', NULL, NULL);
INSERT INTO public.districts VALUES (179, 24, 441, 'Banas Kantha', NULL, NULL);
INSERT INTO public.districts VALUES (180, 24, 442, 'Bharuch', NULL, NULL);
INSERT INTO public.districts VALUES (181, 24, 443, 'Bhavnagar', NULL, NULL);
INSERT INTO public.districts VALUES (182, 24, 676, 'Botad', NULL, NULL);
INSERT INTO public.districts VALUES (183, 24, 668, 'Chhotaudepur', NULL, NULL);
INSERT INTO public.districts VALUES (184, 24, 445, 'Dahod', NULL, NULL);
INSERT INTO public.districts VALUES (185, 24, 444, 'Dangs', NULL, NULL);
INSERT INTO public.districts VALUES (186, 24, 674, 'Devbhumi Dwarka', NULL, NULL);
INSERT INTO public.districts VALUES (187, 24, 446, 'Gandhinagar', NULL, NULL);
INSERT INTO public.districts VALUES (188, 24, 675, 'Gir Somnath', NULL, NULL);
INSERT INTO public.districts VALUES (189, 24, 447, 'Jamnagar', NULL, NULL);
INSERT INTO public.districts VALUES (190, 24, 448, 'Junagadh', NULL, NULL);
INSERT INTO public.districts VALUES (191, 24, 449, 'Kachchh', NULL, NULL);
INSERT INTO public.districts VALUES (192, 24, 450, 'Kheda', NULL, NULL);
INSERT INTO public.districts VALUES (193, 24, 451, 'Mahesana', NULL, NULL);
INSERT INTO public.districts VALUES (194, 24, 669, 'Mahisagar', NULL, NULL);
INSERT INTO public.districts VALUES (195, 24, 673, 'Morbi', NULL, NULL);
INSERT INTO public.districts VALUES (196, 24, 452, 'Narmada', NULL, NULL);
INSERT INTO public.districts VALUES (197, 24, 453, 'Navsari', NULL, NULL);
INSERT INTO public.districts VALUES (198, 24, 454, 'Panch Mahals', NULL, NULL);
INSERT INTO public.districts VALUES (199, 24, 455, 'Patan', NULL, NULL);
INSERT INTO public.districts VALUES (200, 24, 456, 'Porbandar', NULL, NULL);
INSERT INTO public.districts VALUES (201, 24, 457, 'Rajkot', NULL, NULL);
INSERT INTO public.districts VALUES (202, 24, 458, 'Sabar Kantha', NULL, NULL);
INSERT INTO public.districts VALUES (203, 24, 459, 'Surat', NULL, NULL);
INSERT INTO public.districts VALUES (204, 24, 460, 'Surendranagar', NULL, NULL);
INSERT INTO public.districts VALUES (205, 24, 641, 'Tapi', NULL, NULL);
INSERT INTO public.districts VALUES (206, 24, 461, 'Vadodara', NULL, NULL);
INSERT INTO public.districts VALUES (207, 24, 462, 'Valsad', NULL, NULL);
INSERT INTO public.districts VALUES (208, 6, 58, 'Ambala', NULL, NULL);
INSERT INTO public.districts VALUES (209, 6, 59, 'Bhiwani', NULL, NULL);
INSERT INTO public.districts VALUES (210, 6, 701, 'Charki Dadri', NULL, NULL);
INSERT INTO public.districts VALUES (211, 6, 60, 'Faridabad', NULL, NULL);
INSERT INTO public.districts VALUES (212, 6, 61, 'Fatehabad', NULL, NULL);
INSERT INTO public.districts VALUES (213, 6, 62, 'Gurugram', NULL, NULL);
INSERT INTO public.districts VALUES (214, 6, 63, 'Hisar', NULL, NULL);
INSERT INTO public.districts VALUES (215, 6, 64, 'Jhajjar', NULL, NULL);
INSERT INTO public.districts VALUES (216, 6, 65, 'Jind', NULL, NULL);
INSERT INTO public.districts VALUES (217, 6, 66, 'Kaithal', NULL, NULL);
INSERT INTO public.districts VALUES (218, 6, 67, 'Karnal', NULL, NULL);
INSERT INTO public.districts VALUES (219, 6, 68, 'Kurukshetra', NULL, NULL);
INSERT INTO public.districts VALUES (220, 6, 69, 'Mahendragarh', NULL, NULL);
INSERT INTO public.districts VALUES (221, 6, 604, 'Nuh', NULL, NULL);
INSERT INTO public.districts VALUES (222, 6, 619, 'Palwal', NULL, NULL);
INSERT INTO public.districts VALUES (223, 6, 70, 'Panchkula', NULL, NULL);
INSERT INTO public.districts VALUES (224, 6, 71, 'Panipat', NULL, NULL);
INSERT INTO public.districts VALUES (225, 6, 72, 'Rewari', NULL, NULL);
INSERT INTO public.districts VALUES (226, 6, 73, 'Rohtak', NULL, NULL);
INSERT INTO public.districts VALUES (227, 6, 74, 'Sirsa', NULL, NULL);
INSERT INTO public.districts VALUES (228, 6, 75, 'Sonipat', NULL, NULL);
INSERT INTO public.districts VALUES (229, 6, 76, 'Yamunanagar', NULL, NULL);
INSERT INTO public.districts VALUES (230, 2, 15, 'Bilaspur', NULL, NULL);
INSERT INTO public.districts VALUES (231, 2, 16, 'Chamba', NULL, NULL);
INSERT INTO public.districts VALUES (232, 2, 17, 'Hamirpur', NULL, NULL);
INSERT INTO public.districts VALUES (233, 2, 18, 'Kangra', NULL, NULL);
INSERT INTO public.districts VALUES (234, 2, 19, 'Kinnaur', NULL, NULL);
INSERT INTO public.districts VALUES (235, 2, 20, 'Kullu', NULL, NULL);
INSERT INTO public.districts VALUES (236, 2, 21, 'Lahaul And Spiti', NULL, NULL);
INSERT INTO public.districts VALUES (237, 2, 22, 'Mandi', NULL, NULL);
INSERT INTO public.districts VALUES (238, 2, 23, 'Shimla', NULL, NULL);
INSERT INTO public.districts VALUES (239, 2, 24, 'Sirmaur', NULL, NULL);
INSERT INTO public.districts VALUES (240, 2, 25, 'Solan', NULL, NULL);
INSERT INTO public.districts VALUES (241, 2, 26, 'Una', NULL, NULL);
INSERT INTO public.districts VALUES (242, 1, 1, 'Anantnag', NULL, NULL);
INSERT INTO public.districts VALUES (243, 1, 623, 'Bandipora', NULL, NULL);
INSERT INTO public.districts VALUES (244, 1, 3, 'Baramulla', NULL, NULL);
INSERT INTO public.districts VALUES (245, 1, 2, 'Budgam', NULL, NULL);
INSERT INTO public.districts VALUES (246, 1, 4, 'Doda', NULL, NULL);
INSERT INTO public.districts VALUES (247, 1, 626, 'Ganderbal', NULL, NULL);
INSERT INTO public.districts VALUES (248, 1, 5, 'Jammu', NULL, NULL);
INSERT INTO public.districts VALUES (249, 1, 7, 'Kathua', NULL, NULL);
INSERT INTO public.districts VALUES (250, 1, 620, 'Kishtwar', NULL, NULL);
INSERT INTO public.districts VALUES (251, 1, 622, 'Kulgam', NULL, NULL);
INSERT INTO public.districts VALUES (252, 1, 8, 'Kupwara', NULL, NULL);
INSERT INTO public.districts VALUES (253, 1, 10, 'Poonch', NULL, NULL);
INSERT INTO public.districts VALUES (254, 1, 11, 'Pulwama', NULL, NULL);
INSERT INTO public.districts VALUES (255, 1, 12, 'Rajouri', NULL, NULL);
INSERT INTO public.districts VALUES (256, 1, 621, 'Ramban', NULL, NULL);
INSERT INTO public.districts VALUES (257, 1, 627, 'Reasi', NULL, NULL);
INSERT INTO public.districts VALUES (258, 1, 624, 'Samba', NULL, NULL);
INSERT INTO public.districts VALUES (259, 1, 625, 'Shopian', NULL, NULL);
INSERT INTO public.districts VALUES (260, 1, 13, 'Srinagar', NULL, NULL);
INSERT INTO public.districts VALUES (261, 1, 14, 'Udhampur', NULL, NULL);
INSERT INTO public.districts VALUES (262, 20, 322, 'Bokaro', NULL, NULL);
INSERT INTO public.districts VALUES (263, 20, 323, 'Chatra', NULL, NULL);
INSERT INTO public.districts VALUES (264, 20, 324, 'Deoghar', NULL, NULL);
INSERT INTO public.districts VALUES (265, 20, 325, 'Dhanbad', NULL, NULL);
INSERT INTO public.districts VALUES (266, 20, 326, 'Dumka', NULL, NULL);
INSERT INTO public.districts VALUES (267, 20, 327, 'East Singhbum', NULL, NULL);
INSERT INTO public.districts VALUES (268, 20, 328, 'Garhwa', NULL, NULL);
INSERT INTO public.districts VALUES (269, 20, 329, 'Giridih', NULL, NULL);
INSERT INTO public.districts VALUES (270, 20, 330, 'Godda', NULL, NULL);
INSERT INTO public.districts VALUES (271, 20, 331, 'Gumla', NULL, NULL);
INSERT INTO public.districts VALUES (272, 20, 332, 'Hazaribagh', NULL, NULL);
INSERT INTO public.districts VALUES (273, 20, 333, 'Jamtara', NULL, NULL);
INSERT INTO public.districts VALUES (274, 20, 606, 'Khunti', NULL, NULL);
INSERT INTO public.districts VALUES (275, 20, 334, 'Koderma', NULL, NULL);
INSERT INTO public.districts VALUES (276, 20, 335, 'Latehar', NULL, NULL);
INSERT INTO public.districts VALUES (277, 20, 336, 'Lohardaga', NULL, NULL);
INSERT INTO public.districts VALUES (278, 20, 337, 'Pakur', NULL, NULL);
INSERT INTO public.districts VALUES (279, 20, 338, 'Palamu', NULL, NULL);
INSERT INTO public.districts VALUES (280, 20, 607, 'Ramgarh', NULL, NULL);
INSERT INTO public.districts VALUES (281, 20, 339, 'Ranchi', NULL, NULL);
INSERT INTO public.districts VALUES (282, 20, 340, 'Sahebganj', NULL, NULL);
INSERT INTO public.districts VALUES (283, 20, 341, 'Saraikela Kharsawan', NULL, NULL);
INSERT INTO public.districts VALUES (284, 20, 342, 'Simdega', NULL, NULL);
INSERT INTO public.districts VALUES (285, 20, 343, 'West Singhbhum', NULL, NULL);
INSERT INTO public.districts VALUES (286, 29, 524, 'Bagalkote', NULL, NULL);
INSERT INTO public.districts VALUES (287, 29, 528, 'Ballari', NULL, NULL);
INSERT INTO public.districts VALUES (288, 29, 527, 'Belagavi', NULL, NULL);
INSERT INTO public.districts VALUES (289, 29, 526, 'Bengaluru Rural', NULL, NULL);
INSERT INTO public.districts VALUES (290, 29, 525, 'Bengaluru Urban', NULL, NULL);
INSERT INTO public.districts VALUES (291, 29, 529, 'Bidar', NULL, NULL);
INSERT INTO public.districts VALUES (292, 29, 531, 'Chamarajanagara', NULL, NULL);
INSERT INTO public.districts VALUES (293, 29, 630, 'Chikkaballapura', NULL, NULL);
INSERT INTO public.districts VALUES (294, 29, 532, 'Chikkamagaluru', NULL, NULL);
INSERT INTO public.districts VALUES (295, 29, 533, 'Chitradurga', NULL, NULL);
INSERT INTO public.districts VALUES (296, 29, 534, 'Dakshina Kannada', NULL, NULL);
INSERT INTO public.districts VALUES (297, 29, 535, 'Davangere', NULL, NULL);
INSERT INTO public.districts VALUES (298, 29, 536, 'Dharwad', NULL, NULL);
INSERT INTO public.districts VALUES (299, 29, 537, 'Gadag', NULL, NULL);
INSERT INTO public.districts VALUES (300, 29, 539, 'Hassan', NULL, NULL);
INSERT INTO public.districts VALUES (301, 29, 540, 'Haveri', NULL, NULL);
INSERT INTO public.districts VALUES (302, 29, 538, 'Kalaburagi', NULL, NULL);
INSERT INTO public.districts VALUES (303, 29, 541, 'Kodagu', NULL, NULL);
INSERT INTO public.districts VALUES (304, 29, 542, 'Kolar', NULL, NULL);
INSERT INTO public.districts VALUES (305, 29, 543, 'Koppal', NULL, NULL);
INSERT INTO public.districts VALUES (306, 29, 544, 'Mandya', NULL, NULL);
INSERT INTO public.districts VALUES (307, 29, 545, 'Mysuru', NULL, NULL);
INSERT INTO public.districts VALUES (308, 29, 546, 'Raichur', NULL, NULL);
INSERT INTO public.districts VALUES (309, 29, 631, 'Ramanagara', NULL, NULL);
INSERT INTO public.districts VALUES (310, 29, 547, 'Shivamogga', NULL, NULL);
INSERT INTO public.districts VALUES (311, 29, 548, 'Tumakuru', NULL, NULL);
INSERT INTO public.districts VALUES (312, 29, 549, 'Udupi', NULL, NULL);
INSERT INTO public.districts VALUES (313, 29, 550, 'Uttara Kannada', NULL, NULL);
INSERT INTO public.districts VALUES (314, 29, 738, 'Vijayanagar', NULL, NULL);
INSERT INTO public.districts VALUES (315, 29, 530, 'Vijayapura', NULL, NULL);
INSERT INTO public.districts VALUES (316, 29, 635, 'Yadgir', NULL, NULL);
INSERT INTO public.districts VALUES (317, 32, 554, 'Alappuzha', NULL, NULL);
INSERT INTO public.districts VALUES (318, 32, 555, 'Ernakulam', NULL, NULL);
INSERT INTO public.districts VALUES (319, 32, 556, 'Idukki', NULL, NULL);
INSERT INTO public.districts VALUES (320, 32, 557, 'Kannur', NULL, NULL);
INSERT INTO public.districts VALUES (321, 32, 558, 'Kasaragod', NULL, NULL);
INSERT INTO public.districts VALUES (322, 32, 559, 'Kollam', NULL, NULL);
INSERT INTO public.districts VALUES (323, 32, 560, 'Kottayam', NULL, NULL);
INSERT INTO public.districts VALUES (324, 32, 561, 'Kozhikode', NULL, NULL);
INSERT INTO public.districts VALUES (325, 32, 562, 'Malappuram', NULL, NULL);
INSERT INTO public.districts VALUES (326, 32, 563, 'Palakkad', NULL, NULL);
INSERT INTO public.districts VALUES (327, 32, 564, 'Pathanamthitta', NULL, NULL);
INSERT INTO public.districts VALUES (328, 32, 565, 'Thiruvananthapuram', NULL, NULL);
INSERT INTO public.districts VALUES (329, 32, 566, 'Thrissur', NULL, NULL);
INSERT INTO public.districts VALUES (330, 32, 567, 'Wayanad', NULL, NULL);
INSERT INTO public.districts VALUES (331, 37, 6, 'Kargil', NULL, NULL);
INSERT INTO public.districts VALUES (332, 37, 9, 'Leh Ladakh', NULL, NULL);
INSERT INTO public.districts VALUES (333, 31, 553, 'Lakshadweep District', NULL, NULL);
INSERT INTO public.districts VALUES (334, 23, 667, 'Agar-Malwa', NULL, NULL);
INSERT INTO public.districts VALUES (335, 23, 639, 'Alirajpur', NULL, NULL);
INSERT INTO public.districts VALUES (336, 23, 390, 'Anuppur', NULL, NULL);
INSERT INTO public.districts VALUES (337, 23, 391, 'Ashoknagar', NULL, NULL);
INSERT INTO public.districts VALUES (338, 23, 392, 'Balaghat', NULL, NULL);
INSERT INTO public.districts VALUES (339, 23, 393, 'Barwani', NULL, NULL);
INSERT INTO public.districts VALUES (340, 23, 394, 'Betul', NULL, NULL);
INSERT INTO public.districts VALUES (341, 23, 395, 'Bhind', NULL, NULL);
INSERT INTO public.districts VALUES (342, 23, 396, 'Bhopal', NULL, NULL);
INSERT INTO public.districts VALUES (343, 23, 397, 'Burhanpur', NULL, NULL);
INSERT INTO public.districts VALUES (344, 23, 398, 'Chhatarpur', NULL, NULL);
INSERT INTO public.districts VALUES (345, 23, 399, 'Chhindwara', NULL, NULL);
INSERT INTO public.districts VALUES (346, 23, 400, 'Damoh', NULL, NULL);
INSERT INTO public.districts VALUES (347, 23, 401, 'Datia', NULL, NULL);
INSERT INTO public.districts VALUES (348, 23, 402, 'Dewas', NULL, NULL);
INSERT INTO public.districts VALUES (349, 23, 403, 'Dhar', NULL, NULL);
INSERT INTO public.districts VALUES (350, 23, 404, 'Dindori', NULL, NULL);
INSERT INTO public.districts VALUES (351, 23, 406, 'Guna', NULL, NULL);
INSERT INTO public.districts VALUES (352, 23, 407, 'Gwalior', NULL, NULL);
INSERT INTO public.districts VALUES (353, 23, 408, 'Harda', NULL, NULL);
INSERT INTO public.districts VALUES (354, 23, 410, 'Indore', NULL, NULL);
INSERT INTO public.districts VALUES (355, 23, 411, 'Jabalpur', NULL, NULL);
INSERT INTO public.districts VALUES (356, 23, 412, 'Jhabua', NULL, NULL);
INSERT INTO public.districts VALUES (357, 23, 413, 'Katni', NULL, NULL);
INSERT INTO public.districts VALUES (358, 23, 405, 'Khandwa (East Nimar)', NULL, NULL);
INSERT INTO public.districts VALUES (359, 23, 414, 'Khargone (West Nimar)', NULL, NULL);
INSERT INTO public.districts VALUES (360, 23, 784, 'Maihar', NULL, NULL);
INSERT INTO public.districts VALUES (361, 23, 415, 'Mandla', NULL, NULL);
INSERT INTO public.districts VALUES (362, 23, 416, 'Mandsaur', NULL, NULL);
INSERT INTO public.districts VALUES (363, 23, 766, 'MAUGANJ', NULL, NULL);
INSERT INTO public.districts VALUES (364, 23, 417, 'Morena', NULL, NULL);
INSERT INTO public.districts VALUES (365, 23, 409, 'Narmadapuram', NULL, NULL);
INSERT INTO public.districts VALUES (366, 23, 418, 'Narsimhapur', NULL, NULL);
INSERT INTO public.districts VALUES (367, 23, 419, 'Neemuch', NULL, NULL);
INSERT INTO public.districts VALUES (368, 23, 722, 'Niwari', NULL, NULL);
INSERT INTO public.districts VALUES (369, 23, 785, 'Pandhurna', NULL, NULL);
INSERT INTO public.districts VALUES (370, 23, 420, 'Panna', NULL, NULL);
INSERT INTO public.districts VALUES (371, 23, 421, 'Raisen', NULL, NULL);
INSERT INTO public.districts VALUES (372, 23, 422, 'Rajgarh', NULL, NULL);
INSERT INTO public.districts VALUES (373, 23, 423, 'Ratlam', NULL, NULL);
INSERT INTO public.districts VALUES (374, 23, 424, 'Rewa', NULL, NULL);
INSERT INTO public.districts VALUES (375, 23, 425, 'Sagar', NULL, NULL);
INSERT INTO public.districts VALUES (376, 23, 426, 'Satna', NULL, NULL);
INSERT INTO public.districts VALUES (377, 23, 427, 'Sehore', NULL, NULL);
INSERT INTO public.districts VALUES (378, 23, 428, 'Seoni', NULL, NULL);
INSERT INTO public.districts VALUES (379, 23, 429, 'Shahdol', NULL, NULL);
INSERT INTO public.districts VALUES (380, 23, 430, 'Shajapur', NULL, NULL);
INSERT INTO public.districts VALUES (381, 23, 431, 'Sheopur', NULL, NULL);
INSERT INTO public.districts VALUES (382, 23, 432, 'Shivpuri', NULL, NULL);
INSERT INTO public.districts VALUES (383, 23, 433, 'Sidhi', NULL, NULL);
INSERT INTO public.districts VALUES (384, 23, 638, 'Singrauli', NULL, NULL);
INSERT INTO public.districts VALUES (385, 23, 434, 'Tikamgarh', NULL, NULL);
INSERT INTO public.districts VALUES (386, 23, 435, 'Ujjain', NULL, NULL);
INSERT INTO public.districts VALUES (387, 23, 436, 'Umaria', NULL, NULL);
INSERT INTO public.districts VALUES (388, 23, 437, 'Vidisha', NULL, NULL);
INSERT INTO public.districts VALUES (389, 27, 466, 'Ahmednagar', NULL, NULL);
INSERT INTO public.districts VALUES (390, 27, 467, 'Akola', NULL, NULL);
INSERT INTO public.districts VALUES (391, 27, 468, 'Amravati', NULL, NULL);
INSERT INTO public.districts VALUES (392, 27, 470, 'Beed', NULL, NULL);
INSERT INTO public.districts VALUES (393, 27, 471, 'Bhandara', NULL, NULL);
INSERT INTO public.districts VALUES (394, 27, 472, 'Buldhana', NULL, NULL);
INSERT INTO public.districts VALUES (395, 27, 473, 'Chandrapur', NULL, NULL);
INSERT INTO public.districts VALUES (396, 21, 368, 'Nuapada', NULL, NULL);
INSERT INTO public.districts VALUES (397, 27, 469, 'Chhatrapati Sambhajinagar', NULL, NULL);
INSERT INTO public.districts VALUES (398, 27, 488, 'Dharashiv', NULL, NULL);
INSERT INTO public.districts VALUES (399, 27, 474, 'Dhule', NULL, NULL);
INSERT INTO public.districts VALUES (400, 27, 475, 'Gadchiroli', NULL, NULL);
INSERT INTO public.districts VALUES (401, 27, 476, 'Gondia', NULL, NULL);
INSERT INTO public.districts VALUES (402, 27, 477, 'Hingoli', NULL, NULL);
INSERT INTO public.districts VALUES (403, 27, 478, 'Jalgaon', NULL, NULL);
INSERT INTO public.districts VALUES (404, 27, 479, 'Jalna', NULL, NULL);
INSERT INTO public.districts VALUES (405, 27, 480, 'Kolhapur', NULL, NULL);
INSERT INTO public.districts VALUES (406, 27, 481, 'Latur', NULL, NULL);
INSERT INTO public.districts VALUES (407, 27, 482, 'Mumbai', NULL, NULL);
INSERT INTO public.districts VALUES (408, 27, 483, 'Mumbai Suburban', NULL, NULL);
INSERT INTO public.districts VALUES (409, 27, 484, 'Nagpur', NULL, NULL);
INSERT INTO public.districts VALUES (410, 27, 485, 'Nanded', NULL, NULL);
INSERT INTO public.districts VALUES (411, 27, 486, 'Nandurbar', NULL, NULL);
INSERT INTO public.districts VALUES (412, 27, 487, 'Nashik', NULL, NULL);
INSERT INTO public.districts VALUES (413, 27, 665, 'Palghar', NULL, NULL);
INSERT INTO public.districts VALUES (414, 27, 489, 'Parbhani', NULL, NULL);
INSERT INTO public.districts VALUES (415, 27, 490, 'Pune', NULL, NULL);
INSERT INTO public.districts VALUES (416, 27, 491, 'Raigad', NULL, NULL);
INSERT INTO public.districts VALUES (417, 27, 492, 'Ratnagiri', NULL, NULL);
INSERT INTO public.districts VALUES (418, 27, 493, 'Sangli', NULL, NULL);
INSERT INTO public.districts VALUES (419, 27, 494, 'Satara', NULL, NULL);
INSERT INTO public.districts VALUES (420, 27, 495, 'Sindhudurg', NULL, NULL);
INSERT INTO public.districts VALUES (421, 27, 496, 'Solapur', NULL, NULL);
INSERT INTO public.districts VALUES (422, 27, 497, 'Thane', NULL, NULL);
INSERT INTO public.districts VALUES (423, 27, 498, 'Wardha', NULL, NULL);
INSERT INTO public.districts VALUES (424, 27, 499, 'Washim', NULL, NULL);
INSERT INTO public.districts VALUES (425, 27, 500, 'Yavatmal', NULL, NULL);
INSERT INTO public.districts VALUES (426, 14, 252, 'Bishnupur', NULL, NULL);
INSERT INTO public.districts VALUES (427, 14, 253, 'Chandel', NULL, NULL);
INSERT INTO public.districts VALUES (428, 14, 254, 'Churachandpur', NULL, NULL);
INSERT INTO public.districts VALUES (429, 14, 255, 'Imphal East', NULL, NULL);
INSERT INTO public.districts VALUES (430, 14, 256, 'Imphal West', NULL, NULL);
INSERT INTO public.districts VALUES (431, 14, 713, 'Jiribam', NULL, NULL);
INSERT INTO public.districts VALUES (432, 14, 711, 'Kakching', NULL, NULL);
INSERT INTO public.districts VALUES (433, 14, 717, 'Kamjong', NULL, NULL);
INSERT INTO public.districts VALUES (434, 14, 712, 'Kangpokpi', NULL, NULL);
INSERT INTO public.districts VALUES (435, 14, 714, 'Noney', NULL, NULL);
INSERT INTO public.districts VALUES (436, 14, 715, 'Pherzawl', NULL, NULL);
INSERT INTO public.districts VALUES (437, 14, 257, 'Senapati', NULL, NULL);
INSERT INTO public.districts VALUES (438, 14, 258, 'Tamenglong', NULL, NULL);
INSERT INTO public.districts VALUES (439, 14, 716, 'Tengnoupal', NULL, NULL);
INSERT INTO public.districts VALUES (440, 14, 259, 'Thoubal', NULL, NULL);
INSERT INTO public.districts VALUES (441, 14, 260, 'Ukhrul', NULL, NULL);
INSERT INTO public.districts VALUES (442, 17, 740, 'Eastern West Khasi Hills', NULL, NULL);
INSERT INTO public.districts VALUES (443, 17, 273, 'East Garo Hills', NULL, NULL);
INSERT INTO public.districts VALUES (444, 17, 657, 'East Jaintia Hills', NULL, NULL);
INSERT INTO public.districts VALUES (445, 17, 274, 'East Khasi Hills', NULL, NULL);
INSERT INTO public.districts VALUES (446, 17, 656, 'North Garo Hills', NULL, NULL);
INSERT INTO public.districts VALUES (447, 17, 276, 'Ri Bhoi', NULL, NULL);
INSERT INTO public.districts VALUES (448, 17, 277, 'South Garo Hills', NULL, NULL);
INSERT INTO public.districts VALUES (449, 17, 663, 'South West Garo Hills', NULL, NULL);
INSERT INTO public.districts VALUES (450, 17, 658, 'South West Khasi Hills', NULL, NULL);
INSERT INTO public.districts VALUES (451, 17, 278, 'West Garo Hills', NULL, NULL);
INSERT INTO public.districts VALUES (452, 17, 275, 'West Jaintia Hills', NULL, NULL);
INSERT INTO public.districts VALUES (453, 17, 279, 'West Khasi Hills', NULL, NULL);
INSERT INTO public.districts VALUES (454, 15, 261, 'Aizawl', NULL, NULL);
INSERT INTO public.districts VALUES (455, 15, 262, 'Champhai', NULL, NULL);
INSERT INTO public.districts VALUES (456, 15, 726, 'Hnahthial', NULL, NULL);
INSERT INTO public.districts VALUES (457, 15, 728, 'Khawzawl', NULL, NULL);
INSERT INTO public.districts VALUES (458, 15, 263, 'Kolasib', NULL, NULL);
INSERT INTO public.districts VALUES (459, 15, 264, 'Lawngtlai', NULL, NULL);
INSERT INTO public.districts VALUES (460, 15, 265, 'Lunglei', NULL, NULL);
INSERT INTO public.districts VALUES (461, 15, 266, 'Mamit', NULL, NULL);
INSERT INTO public.districts VALUES (462, 15, 727, 'Saitual', NULL, NULL);
INSERT INTO public.districts VALUES (463, 15, 268, 'Serchhip', NULL, NULL);
INSERT INTO public.districts VALUES (464, 15, 267, 'Siaha', NULL, NULL);
INSERT INTO public.districts VALUES (465, 13, 758, 'Chumoukedima', NULL, NULL);
INSERT INTO public.districts VALUES (466, 13, 244, 'Dimapur', NULL, NULL);
INSERT INTO public.districts VALUES (467, 13, 614, 'Kiphire', NULL, NULL);
INSERT INTO public.districts VALUES (468, 13, 245, 'Kohima', NULL, NULL);
INSERT INTO public.districts VALUES (469, 13, 615, 'Longleng', NULL, NULL);
INSERT INTO public.districts VALUES (470, 13, 246, 'Mokokchung', NULL, NULL);
INSERT INTO public.districts VALUES (471, 13, 247, 'Mon', NULL, NULL);
INSERT INTO public.districts VALUES (472, 13, 764, 'Niuland', NULL, NULL);
INSERT INTO public.districts VALUES (473, 13, 736, 'Noklak', NULL, NULL);
INSERT INTO public.districts VALUES (474, 13, 613, 'Peren', NULL, NULL);
INSERT INTO public.districts VALUES (475, 13, 248, 'Phek', NULL, NULL);
INSERT INTO public.districts VALUES (476, 13, 765, 'Shamator', NULL, NULL);
INSERT INTO public.districts VALUES (477, 13, 757, 'Tseminyu', NULL, NULL);
INSERT INTO public.districts VALUES (478, 13, 249, 'Tuensang', NULL, NULL);
INSERT INTO public.districts VALUES (479, 13, 250, 'Wokha', NULL, NULL);
INSERT INTO public.districts VALUES (480, 13, 251, 'Zunheboto', NULL, NULL);
INSERT INTO public.districts VALUES (481, 21, 344, 'Anugul', NULL, NULL);
INSERT INTO public.districts VALUES (482, 21, 345, 'Balangir', NULL, NULL);
INSERT INTO public.districts VALUES (483, 21, 346, 'Baleshwar', NULL, NULL);
INSERT INTO public.districts VALUES (484, 21, 347, 'Bargarh', NULL, NULL);
INSERT INTO public.districts VALUES (485, 21, 348, 'Bhadrak', NULL, NULL);
INSERT INTO public.districts VALUES (486, 21, 349, 'Boudh', NULL, NULL);
INSERT INTO public.districts VALUES (487, 21, 350, 'Cuttack', NULL, NULL);
INSERT INTO public.districts VALUES (488, 21, 351, 'Deogarh', NULL, NULL);
INSERT INTO public.districts VALUES (489, 21, 352, 'Dhenkanal', NULL, NULL);
INSERT INTO public.districts VALUES (490, 21, 353, 'Gajapati', NULL, NULL);
INSERT INTO public.districts VALUES (491, 21, 354, 'Ganjam', NULL, NULL);
INSERT INTO public.districts VALUES (492, 21, 355, 'Jagatsinghapur', NULL, NULL);
INSERT INTO public.districts VALUES (493, 21, 356, 'Jajapur', NULL, NULL);
INSERT INTO public.districts VALUES (494, 21, 357, 'Jharsuguda', NULL, NULL);
INSERT INTO public.districts VALUES (495, 21, 358, 'Kalahandi', NULL, NULL);
INSERT INTO public.districts VALUES (496, 21, 359, 'Kandhamal', NULL, NULL);
INSERT INTO public.districts VALUES (497, 21, 360, 'Kendrapara', NULL, NULL);
INSERT INTO public.districts VALUES (498, 21, 361, 'Kendujhar', NULL, NULL);
INSERT INTO public.districts VALUES (499, 21, 362, 'Khordha', NULL, NULL);
INSERT INTO public.districts VALUES (500, 21, 363, 'Koraput', NULL, NULL);
INSERT INTO public.districts VALUES (501, 21, 364, 'Malkangiri', NULL, NULL);
INSERT INTO public.districts VALUES (502, 21, 365, 'Mayurbhanj', NULL, NULL);
INSERT INTO public.districts VALUES (503, 21, 366, 'Nabarangpur', NULL, NULL);
INSERT INTO public.districts VALUES (504, 21, 367, 'Nayagarh', NULL, NULL);
INSERT INTO public.districts VALUES (505, 21, 369, 'Puri', NULL, NULL);
INSERT INTO public.districts VALUES (506, 21, 370, 'Rayagada', NULL, NULL);
INSERT INTO public.districts VALUES (507, 21, 371, 'Sambalpur', NULL, NULL);
INSERT INTO public.districts VALUES (508, 21, 372, 'Sonepur', NULL, NULL);
INSERT INTO public.districts VALUES (509, 21, 373, 'Sundargarh', NULL, NULL);
INSERT INTO public.districts VALUES (510, 34, 598, 'Karaikal', NULL, NULL);
INSERT INTO public.districts VALUES (511, 34, 599, 'Mahe', NULL, NULL);
INSERT INTO public.districts VALUES (512, 34, 600, 'Pondicherry', NULL, NULL);
INSERT INTO public.districts VALUES (513, 34, 601, 'Yanam', NULL, NULL);
INSERT INTO public.districts VALUES (514, 3, 27, 'Amritsar', NULL, NULL);
INSERT INTO public.districts VALUES (515, 3, 605, 'Barnala', NULL, NULL);
INSERT INTO public.districts VALUES (516, 3, 28, 'Bathinda', NULL, NULL);
INSERT INTO public.districts VALUES (517, 3, 29, 'Faridkot', NULL, NULL);
INSERT INTO public.districts VALUES (518, 3, 30, 'Fatehgarh Sahib', NULL, NULL);
INSERT INTO public.districts VALUES (519, 3, 651, 'Fazilka', NULL, NULL);
INSERT INTO public.districts VALUES (520, 3, 31, 'Ferozepur', NULL, NULL);
INSERT INTO public.districts VALUES (521, 3, 32, 'Gurdaspur', NULL, NULL);
INSERT INTO public.districts VALUES (522, 3, 33, 'Hoshiarpur', NULL, NULL);
INSERT INTO public.districts VALUES (523, 3, 34, 'Jalandhar', NULL, NULL);
INSERT INTO public.districts VALUES (524, 3, 35, 'Kapurthala', NULL, NULL);
INSERT INTO public.districts VALUES (525, 3, 36, 'Ludhiana', NULL, NULL);
INSERT INTO public.districts VALUES (526, 3, 737, 'Malerkotla', NULL, NULL);
INSERT INTO public.districts VALUES (527, 3, 37, 'Mansa', NULL, NULL);
INSERT INTO public.districts VALUES (528, 3, 38, 'Moga', NULL, NULL);
INSERT INTO public.districts VALUES (529, 3, 662, 'Pathankot', NULL, NULL);
INSERT INTO public.districts VALUES (530, 3, 41, 'Patiala', NULL, NULL);
INSERT INTO public.districts VALUES (531, 3, 42, 'Rupnagar', NULL, NULL);
INSERT INTO public.districts VALUES (532, 3, 43, 'Sangrur', NULL, NULL);
INSERT INTO public.districts VALUES (533, 3, 608, 'S.A.S Nagar', NULL, NULL);
INSERT INTO public.districts VALUES (534, 3, 40, 'Shahid Bhagat Singh Nagar', NULL, NULL);
INSERT INTO public.districts VALUES (535, 3, 39, 'Sri Muktsar Sahib', NULL, NULL);
INSERT INTO public.districts VALUES (536, 3, 609, 'Tarn Taran', NULL, NULL);
INSERT INTO public.districts VALUES (537, 8, 86, 'Ajmer', NULL, NULL);
INSERT INTO public.districts VALUES (538, 8, 87, 'Alwar', NULL, NULL);
INSERT INTO public.districts VALUES (539, 8, 776, 'Anupgarh', NULL, NULL);
INSERT INTO public.districts VALUES (540, 8, 775, 'Balotra', NULL, NULL);
INSERT INTO public.districts VALUES (541, 8, 88, 'Banswara', NULL, NULL);
INSERT INTO public.districts VALUES (542, 8, 89, 'Baran', NULL, NULL);
INSERT INTO public.districts VALUES (543, 8, 90, 'Barmer', NULL, NULL);
INSERT INTO public.districts VALUES (544, 8, 774, 'Beawar', NULL, NULL);
INSERT INTO public.districts VALUES (545, 8, 91, 'Bharatpur', NULL, NULL);
INSERT INTO public.districts VALUES (546, 8, 92, 'Bhilwara', NULL, NULL);
INSERT INTO public.districts VALUES (547, 8, 93, 'Bikaner', NULL, NULL);
INSERT INTO public.districts VALUES (548, 8, 94, 'Bundi', NULL, NULL);
INSERT INTO public.districts VALUES (549, 8, 95, 'Chittorgarh', NULL, NULL);
INSERT INTO public.districts VALUES (550, 8, 96, 'Churu', NULL, NULL);
INSERT INTO public.districts VALUES (551, 8, 97, 'Dausa', NULL, NULL);
INSERT INTO public.districts VALUES (552, 8, 767, 'Deeg', NULL, NULL);
INSERT INTO public.districts VALUES (553, 8, 98, 'Dholpur', NULL, NULL);
INSERT INTO public.districts VALUES (554, 8, 768, 'Didwana-Kuchaman', NULL, NULL);
INSERT INTO public.districts VALUES (555, 8, 769, 'Dudu', NULL, NULL);
INSERT INTO public.districts VALUES (556, 8, 99, 'Dungarpur', NULL, NULL);
INSERT INTO public.districts VALUES (557, 8, 100, 'Ganganagar', NULL, NULL);
INSERT INTO public.districts VALUES (558, 8, 771, 'Gangapurcity', NULL, NULL);
INSERT INTO public.districts VALUES (559, 8, 101, 'Hanumangarh', NULL, NULL);
INSERT INTO public.districts VALUES (560, 8, 102, 'Jaipur', NULL, NULL);
INSERT INTO public.districts VALUES (561, 8, 783, 'Jaipur (Gramin)', NULL, NULL);
INSERT INTO public.districts VALUES (562, 8, 103, 'Jaisalmer', NULL, NULL);
INSERT INTO public.districts VALUES (563, 8, 104, 'Jalore', NULL, NULL);
INSERT INTO public.districts VALUES (564, 8, 105, 'Jhalawar', NULL, NULL);
INSERT INTO public.districts VALUES (565, 8, 106, 'Jhunjhunu', NULL, NULL);
INSERT INTO public.districts VALUES (566, 8, 107, 'Jodhpur', NULL, NULL);
INSERT INTO public.districts VALUES (567, 8, 778, 'Jodhpur (Gramin)', NULL, NULL);
INSERT INTO public.districts VALUES (568, 8, 108, 'Karauli', NULL, NULL);
INSERT INTO public.districts VALUES (569, 8, 781, 'Kekri', NULL, NULL);
INSERT INTO public.districts VALUES (570, 8, 770, 'Khairthal-Tijara', NULL, NULL);
INSERT INTO public.districts VALUES (571, 8, 109, 'Kota', NULL, NULL);
INSERT INTO public.districts VALUES (572, 8, 782, 'Kotputli-Behror', NULL, NULL);
INSERT INTO public.districts VALUES (573, 8, 110, 'Nagaur', NULL, NULL);
INSERT INTO public.districts VALUES (574, 8, 773, 'Neem Ka Thana', NULL, NULL);
INSERT INTO public.districts VALUES (575, 8, 111, 'Pali', NULL, NULL);
INSERT INTO public.districts VALUES (576, 8, 772, 'Phalodi', NULL, NULL);
INSERT INTO public.districts VALUES (577, 8, 629, 'Pratapgarh', NULL, NULL);
INSERT INTO public.districts VALUES (578, 8, 112, 'Rajsamand', NULL, NULL);
INSERT INTO public.districts VALUES (579, 8, 777, 'Salumbar', NULL, NULL);
INSERT INTO public.districts VALUES (580, 8, 779, 'Sanchore', NULL, NULL);
INSERT INTO public.districts VALUES (581, 8, 113, 'Sawai Madhopur', NULL, NULL);
INSERT INTO public.districts VALUES (582, 8, 780, 'Shahpura', NULL, NULL);
INSERT INTO public.districts VALUES (583, 8, 114, 'Sikar', NULL, NULL);
INSERT INTO public.districts VALUES (584, 8, 115, 'Sirohi', NULL, NULL);
INSERT INTO public.districts VALUES (585, 8, 116, 'Tonk', NULL, NULL);
INSERT INTO public.districts VALUES (586, 8, 117, 'Udaipur', NULL, NULL);
INSERT INTO public.districts VALUES (587, 11, 225, 'Gangtok', NULL, NULL);
INSERT INTO public.districts VALUES (588, 11, 228, 'Gyalshing', NULL, NULL);
INSERT INTO public.districts VALUES (589, 11, 226, 'Mangan', NULL, NULL);
INSERT INTO public.districts VALUES (590, 11, 227, 'Namchi', NULL, NULL);
INSERT INTO public.districts VALUES (591, 11, 741, 'Pakyong', NULL, NULL);
INSERT INTO public.districts VALUES (592, 11, 742, 'Soreng', NULL, NULL);
INSERT INTO public.districts VALUES (593, 33, 610, 'Ariyalur', NULL, NULL);
INSERT INTO public.districts VALUES (594, 33, 730, 'Chengalpattu', NULL, NULL);
INSERT INTO public.districts VALUES (595, 33, 568, 'Chennai', NULL, NULL);
INSERT INTO public.districts VALUES (596, 33, 569, 'Coimbatore', NULL, NULL);
INSERT INTO public.districts VALUES (597, 33, 570, 'Cuddalore', NULL, NULL);
INSERT INTO public.districts VALUES (598, 33, 571, 'Dharmapuri', NULL, NULL);
INSERT INTO public.districts VALUES (599, 33, 572, 'Dindigul', NULL, NULL);
INSERT INTO public.districts VALUES (600, 33, 573, 'Erode', NULL, NULL);
INSERT INTO public.districts VALUES (601, 33, 729, 'Kallakurichi', NULL, NULL);
INSERT INTO public.districts VALUES (602, 33, 574, 'Kancheepuram', NULL, NULL);
INSERT INTO public.districts VALUES (603, 33, 575, 'Kanniyakumari', NULL, NULL);
INSERT INTO public.districts VALUES (604, 33, 576, 'Karur', NULL, NULL);
INSERT INTO public.districts VALUES (605, 33, 577, 'Krishnagiri', NULL, NULL);
INSERT INTO public.districts VALUES (606, 33, 578, 'Madurai', NULL, NULL);
INSERT INTO public.districts VALUES (607, 33, 735, 'Mayiladuthurai', NULL, NULL);
INSERT INTO public.districts VALUES (608, 33, 579, 'Nagapattinam', NULL, NULL);
INSERT INTO public.districts VALUES (609, 33, 580, 'Namakkal', NULL, NULL);
INSERT INTO public.districts VALUES (610, 33, 581, 'Perambalur', NULL, NULL);
INSERT INTO public.districts VALUES (611, 33, 582, 'Pudukkottai', NULL, NULL);
INSERT INTO public.districts VALUES (612, 33, 583, 'Ramanathapuram', NULL, NULL);
INSERT INTO public.districts VALUES (613, 33, 731, 'Ranipet', NULL, NULL);
INSERT INTO public.districts VALUES (614, 33, 584, 'Salem', NULL, NULL);
INSERT INTO public.districts VALUES (615, 33, 585, 'Sivaganga', NULL, NULL);
INSERT INTO public.districts VALUES (616, 33, 733, 'Tenkasi', NULL, NULL);
INSERT INTO public.districts VALUES (617, 33, 586, 'Thanjavur', NULL, NULL);
INSERT INTO public.districts VALUES (618, 33, 588, 'Theni', NULL, NULL);
INSERT INTO public.districts VALUES (619, 33, 587, 'The Nilgiris', NULL, NULL);
INSERT INTO public.districts VALUES (620, 33, 589, 'Thiruvallur', NULL, NULL);
INSERT INTO public.districts VALUES (621, 33, 590, 'Thiruvarur', NULL, NULL);
INSERT INTO public.districts VALUES (622, 33, 594, 'Thoothukkudi', NULL, NULL);
INSERT INTO public.districts VALUES (623, 33, 591, 'Tiruchirappalli', NULL, NULL);
INSERT INTO public.districts VALUES (624, 33, 592, 'Tirunelveli', NULL, NULL);
INSERT INTO public.districts VALUES (625, 33, 732, 'Tirupathur', NULL, NULL);
INSERT INTO public.districts VALUES (626, 33, 634, 'Tiruppur', NULL, NULL);
INSERT INTO public.districts VALUES (627, 33, 593, 'Tiruvannamalai', NULL, NULL);
INSERT INTO public.districts VALUES (628, 33, 595, 'Vellore', NULL, NULL);
INSERT INTO public.districts VALUES (629, 33, 596, 'Viluppuram', NULL, NULL);
INSERT INTO public.districts VALUES (630, 33, 597, 'Virudhunagar', NULL, NULL);
INSERT INTO public.districts VALUES (631, 36, 501, 'Adilabad', NULL, NULL);
INSERT INTO public.districts VALUES (632, 36, 690, 'Bhadradri Kothagudem', NULL, NULL);
INSERT INTO public.districts VALUES (633, 36, 686, 'Hanumakonda', NULL, NULL);
INSERT INTO public.districts VALUES (634, 36, 507, 'Hyderabad', NULL, NULL);
INSERT INTO public.districts VALUES (635, 36, 681, 'Jagitial', NULL, NULL);
INSERT INTO public.districts VALUES (636, 36, 689, 'Jangoan', NULL, NULL);
INSERT INTO public.districts VALUES (637, 36, 687, 'Jayashankar Bhupalapally', NULL, NULL);
INSERT INTO public.districts VALUES (638, 36, 695, 'Jogulamba Gadwal', NULL, NULL);
INSERT INTO public.districts VALUES (639, 36, 685, 'Kamareddy', NULL, NULL);
INSERT INTO public.districts VALUES (640, 36, 508, 'Karimnagar', NULL, NULL);
INSERT INTO public.districts VALUES (641, 36, 509, 'Khammam', NULL, NULL);
INSERT INTO public.districts VALUES (642, 36, 699, 'Kumuram Bheem Asifabad', NULL, NULL);
INSERT INTO public.districts VALUES (643, 36, 688, 'Mahabubabad', NULL, NULL);
INSERT INTO public.districts VALUES (644, 36, 512, 'Mahabubnagar', NULL, NULL);
INSERT INTO public.districts VALUES (645, 36, 684, 'Mancherial', NULL, NULL);
INSERT INTO public.districts VALUES (646, 36, 513, 'Medak', NULL, NULL);
INSERT INTO public.districts VALUES (647, 36, 700, 'Medchal Malkajgiri', NULL, NULL);
INSERT INTO public.districts VALUES (648, 36, 720, 'Mulugu', NULL, NULL);
INSERT INTO public.districts VALUES (649, 36, 694, 'Nagarkurnool', NULL, NULL);
INSERT INTO public.districts VALUES (650, 36, 514, 'Nalgonda', NULL, NULL);
INSERT INTO public.districts VALUES (651, 36, 721, 'Narayanpet', NULL, NULL);
INSERT INTO public.districts VALUES (652, 36, 680, 'Nirmal', NULL, NULL);
INSERT INTO public.districts VALUES (653, 36, 516, 'Nizamabad', NULL, NULL);
INSERT INTO public.districts VALUES (654, 36, 682, 'Peddapalli', NULL, NULL);
INSERT INTO public.districts VALUES (655, 36, 683, 'Rajanna Sircilla', NULL, NULL);
INSERT INTO public.districts VALUES (656, 36, 518, 'Ranga Reddy', NULL, NULL);
INSERT INTO public.districts VALUES (657, 36, 691, 'Sangareddy', NULL, NULL);
INSERT INTO public.districts VALUES (658, 36, 692, 'Siddipet', NULL, NULL);
INSERT INTO public.districts VALUES (659, 36, 696, 'Suryapet', NULL, NULL);
INSERT INTO public.districts VALUES (660, 36, 698, 'Vikarabad', NULL, NULL);
INSERT INTO public.districts VALUES (661, 36, 693, 'Wanaparthy', NULL, NULL);
INSERT INTO public.districts VALUES (662, 36, 522, 'Warangal', NULL, NULL);
INSERT INTO public.districts VALUES (663, 36, 697, 'Yadadri Bhuvanagiri', NULL, NULL);
INSERT INTO public.districts VALUES (664, 38, 465, 'Dadra And Nagar Haveli', NULL, NULL);
INSERT INTO public.districts VALUES (665, 38, 463, 'Daman', NULL, NULL);
INSERT INTO public.districts VALUES (666, 38, 464, 'Diu', NULL, NULL);
INSERT INTO public.districts VALUES (667, 16, 269, 'Dhalai', NULL, NULL);
INSERT INTO public.districts VALUES (668, 16, 654, 'Gomati', NULL, NULL);
INSERT INTO public.districts VALUES (669, 16, 652, 'Khowai', NULL, NULL);
INSERT INTO public.districts VALUES (670, 16, 270, 'North Tripura', NULL, NULL);
INSERT INTO public.districts VALUES (671, 16, 653, 'Sepahijala', NULL, NULL);
INSERT INTO public.districts VALUES (672, 16, 271, 'South Tripura', NULL, NULL);
INSERT INTO public.districts VALUES (673, 16, 655, 'Unakoti', NULL, NULL);
INSERT INTO public.districts VALUES (674, 16, 272, 'West Tripura', NULL, NULL);
INSERT INTO public.districts VALUES (675, 5, 45, 'Almora', NULL, NULL);
INSERT INTO public.districts VALUES (676, 5, 46, 'Bageshwar', NULL, NULL);
INSERT INTO public.districts VALUES (677, 5, 47, 'Chamoli', NULL, NULL);
INSERT INTO public.districts VALUES (678, 5, 48, 'Champawat', NULL, NULL);
INSERT INTO public.districts VALUES (679, 5, 49, 'Dehradun', NULL, NULL);
INSERT INTO public.districts VALUES (680, 5, 50, 'Haridwar', NULL, NULL);
INSERT INTO public.districts VALUES (681, 5, 51, 'Nainital', NULL, NULL);
INSERT INTO public.districts VALUES (682, 5, 52, 'Pauri Garhwal', NULL, NULL);
INSERT INTO public.districts VALUES (683, 5, 53, 'Pithoragarh', NULL, NULL);
INSERT INTO public.districts VALUES (684, 5, 54, 'Rudra Prayag', NULL, NULL);
INSERT INTO public.districts VALUES (685, 5, 55, 'Tehri Garhwal', NULL, NULL);
INSERT INTO public.districts VALUES (686, 5, 56, 'Udam Singh Nagar', NULL, NULL);
INSERT INTO public.districts VALUES (687, 5, 57, 'Uttar Kashi', NULL, NULL);
INSERT INTO public.districts VALUES (688, 9, 118, 'Agra', NULL, NULL);
INSERT INTO public.districts VALUES (689, 9, 119, 'Aligarh', NULL, NULL);
INSERT INTO public.districts VALUES (690, 9, 121, 'Ambedkar Nagar', NULL, NULL);
INSERT INTO public.districts VALUES (691, 9, 640, 'Amethi', NULL, NULL);
INSERT INTO public.districts VALUES (692, 9, 154, 'Amroha', NULL, NULL);
INSERT INTO public.districts VALUES (693, 9, 122, 'Auraiya', NULL, NULL);
INSERT INTO public.districts VALUES (694, 9, 140, 'Ayodhya', NULL, NULL);
INSERT INTO public.districts VALUES (695, 9, 123, 'Azamgarh', NULL, NULL);
INSERT INTO public.districts VALUES (696, 9, 124, 'Baghpat', NULL, NULL);
INSERT INTO public.districts VALUES (697, 9, 125, 'Bahraich', NULL, NULL);
INSERT INTO public.districts VALUES (698, 9, 126, 'Ballia', NULL, NULL);
INSERT INTO public.districts VALUES (699, 9, 127, 'Balrampur', NULL, NULL);
INSERT INTO public.districts VALUES (700, 9, 128, 'Banda', NULL, NULL);
INSERT INTO public.districts VALUES (701, 9, 129, 'Bara Banki', NULL, NULL);
INSERT INTO public.districts VALUES (702, 9, 130, 'Bareilly', NULL, NULL);
INSERT INTO public.districts VALUES (703, 9, 131, 'Basti', NULL, NULL);
INSERT INTO public.districts VALUES (704, 9, 179, 'Bhadohi', NULL, NULL);
INSERT INTO public.districts VALUES (705, 9, 132, 'Bijnor', NULL, NULL);
INSERT INTO public.districts VALUES (706, 9, 133, 'Budaun', NULL, NULL);
INSERT INTO public.districts VALUES (707, 9, 134, 'Bulandshahr', NULL, NULL);
INSERT INTO public.districts VALUES (708, 9, 135, 'Chandauli', NULL, NULL);
INSERT INTO public.districts VALUES (709, 9, 136, 'Chitrakoot', NULL, NULL);
INSERT INTO public.districts VALUES (710, 9, 137, 'Deoria', NULL, NULL);
INSERT INTO public.districts VALUES (711, 9, 138, 'Etah', NULL, NULL);
INSERT INTO public.districts VALUES (712, 9, 139, 'Etawah', NULL, NULL);
INSERT INTO public.districts VALUES (713, 9, 141, 'Farrukhabad', NULL, NULL);
INSERT INTO public.districts VALUES (714, 9, 142, 'Fatehpur', NULL, NULL);
INSERT INTO public.districts VALUES (715, 9, 143, 'Firozabad', NULL, NULL);
INSERT INTO public.districts VALUES (716, 9, 144, 'Gautam Buddha Nagar', NULL, NULL);
INSERT INTO public.districts VALUES (717, 9, 145, 'Ghaziabad', NULL, NULL);
INSERT INTO public.districts VALUES (718, 9, 146, 'Ghazipur', NULL, NULL);
INSERT INTO public.districts VALUES (719, 9, 147, 'Gonda', NULL, NULL);
INSERT INTO public.districts VALUES (720, 9, 148, 'Gorakhpur', NULL, NULL);
INSERT INTO public.districts VALUES (721, 9, 149, 'Hamirpur', NULL, NULL);
INSERT INTO public.districts VALUES (722, 9, 661, 'Hapur', NULL, NULL);
INSERT INTO public.districts VALUES (723, 9, 150, 'Hardoi', NULL, NULL);
INSERT INTO public.districts VALUES (724, 9, 163, 'Hathras', NULL, NULL);
INSERT INTO public.districts VALUES (725, 9, 151, 'Jalaun', NULL, NULL);
INSERT INTO public.districts VALUES (726, 9, 152, 'Jaunpur', NULL, NULL);
INSERT INTO public.districts VALUES (727, 9, 153, 'Jhansi', NULL, NULL);
INSERT INTO public.districts VALUES (728, 9, 155, 'Kannauj', NULL, NULL);
INSERT INTO public.districts VALUES (729, 9, 156, 'Kanpur Dehat', NULL, NULL);
INSERT INTO public.districts VALUES (730, 9, 157, 'Kanpur Nagar', NULL, NULL);
INSERT INTO public.districts VALUES (731, 9, 633, 'Kasganj', NULL, NULL);
INSERT INTO public.districts VALUES (732, 9, 158, 'Kaushambi', NULL, NULL);
INSERT INTO public.districts VALUES (733, 9, 159, 'Kheri', NULL, NULL);
INSERT INTO public.districts VALUES (734, 9, 160, 'Kushinagar', NULL, NULL);
INSERT INTO public.districts VALUES (735, 9, 161, 'Lalitpur', NULL, NULL);
INSERT INTO public.districts VALUES (736, 9, 162, 'Lucknow', NULL, NULL);
INSERT INTO public.districts VALUES (737, 9, 165, 'Mahoba', NULL, NULL);
INSERT INTO public.districts VALUES (738, 9, 164, 'Mahrajganj', NULL, NULL);
INSERT INTO public.districts VALUES (739, 9, 166, 'Mainpuri', NULL, NULL);
INSERT INTO public.districts VALUES (740, 9, 167, 'Mathura', NULL, NULL);
INSERT INTO public.districts VALUES (741, 9, 168, 'Mau', NULL, NULL);
INSERT INTO public.districts VALUES (742, 9, 169, 'Meerut', NULL, NULL);
INSERT INTO public.districts VALUES (743, 9, 170, 'Mirzapur', NULL, NULL);
INSERT INTO public.districts VALUES (744, 9, 171, 'Moradabad', NULL, NULL);
INSERT INTO public.districts VALUES (745, 9, 172, 'Muzaffarnagar', NULL, NULL);
INSERT INTO public.districts VALUES (746, 9, 173, 'Pilibhit', NULL, NULL);
INSERT INTO public.districts VALUES (747, 9, 174, 'Pratapgarh', NULL, NULL);
INSERT INTO public.districts VALUES (748, 9, 120, 'Prayagraj', NULL, NULL);
INSERT INTO public.districts VALUES (749, 9, 175, 'Rae Bareli', NULL, NULL);
INSERT INTO public.districts VALUES (750, 9, 176, 'Rampur', NULL, NULL);
INSERT INTO public.districts VALUES (751, 9, 177, 'Saharanpur', NULL, NULL);
INSERT INTO public.districts VALUES (752, 9, 659, 'Sambhal', NULL, NULL);
INSERT INTO public.districts VALUES (753, 9, 178, 'Sant Kabir Nagar', NULL, NULL);
INSERT INTO public.districts VALUES (754, 9, 180, 'Shahjahanpur', NULL, NULL);
INSERT INTO public.districts VALUES (755, 9, 660, 'Shamli', NULL, NULL);
INSERT INTO public.districts VALUES (756, 9, 181, 'Shrawasti', NULL, NULL);
INSERT INTO public.districts VALUES (757, 9, 182, 'Siddharthnagar', NULL, NULL);
INSERT INTO public.districts VALUES (758, 9, 183, 'Sitapur', NULL, NULL);
INSERT INTO public.districts VALUES (759, 9, 184, 'Sonbhadra', NULL, NULL);
INSERT INTO public.districts VALUES (760, 9, 185, 'Sultanpur', NULL, NULL);
INSERT INTO public.districts VALUES (761, 9, 186, 'Unnao', NULL, NULL);
INSERT INTO public.districts VALUES (762, 9, 187, 'Varanasi', NULL, NULL);
INSERT INTO public.districts VALUES (763, 19, 664, 'Alipurduar', NULL, NULL);
INSERT INTO public.districts VALUES (764, 19, 305, 'Bankura', NULL, NULL);
INSERT INTO public.districts VALUES (765, 19, 307, 'Birbhum', NULL, NULL);
INSERT INTO public.districts VALUES (766, 19, 308, 'Cooch Behar', NULL, NULL);
INSERT INTO public.districts VALUES (767, 19, 310, 'Dakshin Dinajpur', NULL, NULL);
INSERT INTO public.districts VALUES (768, 19, 309, 'Darjeeling', NULL, NULL);
INSERT INTO public.districts VALUES (769, 19, 312, 'Hooghly', NULL, NULL);
INSERT INTO public.districts VALUES (770, 19, 313, 'Howrah', NULL, NULL);
INSERT INTO public.districts VALUES (771, 19, 314, 'Jalpaiguri', NULL, NULL);
INSERT INTO public.districts VALUES (772, 19, 703, 'Jhargram', NULL, NULL);
INSERT INTO public.districts VALUES (773, 19, 702, 'Kalimpong', NULL, NULL);
INSERT INTO public.districts VALUES (774, 19, 315, 'Kolkata', NULL, NULL);
INSERT INTO public.districts VALUES (775, 19, 316, 'Malda', NULL, NULL);
INSERT INTO public.districts VALUES (776, 19, 319, 'Murshidabad', NULL, NULL);
INSERT INTO public.districts VALUES (777, 19, 320, 'Nadia', NULL, NULL);
INSERT INTO public.districts VALUES (778, 19, 303, 'North 24 Parganas', NULL, NULL);
INSERT INTO public.districts VALUES (779, 19, 704, 'Paschim Bardhaman', NULL, NULL);
INSERT INTO public.districts VALUES (780, 19, 318, 'Paschim Medinipur', NULL, NULL);
INSERT INTO public.districts VALUES (781, 19, 306, 'Purba Bardhaman', NULL, NULL);
INSERT INTO public.districts VALUES (782, 19, 317, 'Purba Medinipur', NULL, NULL);
INSERT INTO public.districts VALUES (783, 19, 321, 'Purulia', NULL, NULL);
INSERT INTO public.districts VALUES (784, 19, 304, 'South 24 Parganas', NULL, NULL);
INSERT INTO public.districts VALUES (785, 19, 311, 'Uttar Dinajpur', NULL, NULL);


--
-- TOC entry 4967 (class 0 OID 0)
-- Dependencies: 241
-- Name: districts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.districts_id_seq', 785, true);


--
-- TOC entry 4815 (class 2606 OID 31506)
-- Name: districts districts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (id);


-- Completed on 2025-11-28 14:08:13

--
-- PostgreSQL database dump complete
--

\unrestrict KIAXbYlOamsDaN6T5BxH8Wrmm2Kl6qCSTNMtgeTvGyMK24JaiUoMhG4VjzwNmnc

