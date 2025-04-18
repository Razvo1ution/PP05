PGDMP                      }            otel    17.4    17.4 D               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false                       1262    16390    otel    DATABASE     j   CREATE DATABASE otel WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'ru-RU';
    DROP DATABASE otel;
                     postgres    false            �            1259    16411    бронирования    TABLE        CREATE TABLE public."бронирования" (
    "бронирование_id" integer NOT NULL,
    "гость_id" integer,
    "номер_id" integer,
    "дата_заезда" date NOT NULL,
    "дата_выезда" date NOT NULL,
    "статус" character varying(20) NOT NULL,
    CONSTRAINT "бронирования_статус_check" CHECK ((("статус")::text = ANY ((ARRAY['Подтверждено'::character varying, 'Отменено'::character varying, 'Завершено'::character varying])::text[])))
);
 .   DROP TABLE public."бронирования";
       public         heap r       postgres    false            �            1259    16410 8   бронирования_бронирование_id_seq    SEQUENCE     �   CREATE SEQUENCE public."бронирования_бронирование_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 Q   DROP SEQUENCE public."бронирования_бронирование_id_seq";
       public               postgres    false    222                       0    0 8   бронирования_бронирование_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public."бронирования_бронирование_id_seq" OWNED BY public."бронирования"."бронирование_id";
          public               postgres    false    221            �            1259    16402 
   гости    TABLE       CREATE TABLE public."гости" (
    "гость_id" integer NOT NULL,
    "ФИО" character varying(100) NOT NULL,
    "телефон" character varying(20),
    email character varying(100),
    "паспортный_номер" character varying(50) NOT NULL
);
     DROP TABLE public."гости";
       public         heap r       postgres    false            �            1259    16401    гости_гость_id_seq    SEQUENCE     �   CREATE SEQUENCE public."гости_гость_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public."гости_гость_id_seq";
       public               postgres    false    220                       0    0    гости_гость_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public."гости_гость_id_seq" OWNED BY public."гости"."гость_id";
          public               postgres    false    219            �            1259    16392    номера    TABLE     D  CREATE TABLE public."номера" (
    "номер_id" integer NOT NULL,
    "номер" character varying(10) NOT NULL,
    "тип_номера" character varying(50) NOT NULL,
    "статус" character varying(20) NOT NULL,
    "цена" numeric(10,2) NOT NULL,
    CONSTRAINT "номера_статус_check" CHECK ((("статус")::text = ANY ((ARRAY['Свободен'::character varying, 'Занят'::character varying, 'Грязный'::character varying, 'Назначен к уборке'::character varying, 'Чистый'::character varying])::text[])))
);
 "   DROP TABLE public."номера";
       public         heap r       postgres    false            �            1259    16391    номера_номер_id_seq    SEQUENCE     �   CREATE SEQUENCE public."номера_номер_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public."номера_номер_id_seq";
       public               postgres    false    218                       0    0    номера_номер_id_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public."номера_номер_id_seq" OWNED BY public."номера"."номер_id";
          public               postgres    false    217            �            1259    16494    отчеты    TABLE     I  CREATE TABLE public."отчеты" (
    "отчет_id" integer NOT NULL,
    "тип_отчета" character varying(50) NOT NULL,
    "дата_создания" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "объект_id" integer,
    "тип_объекта" character varying(50),
    "данные" json
);
 "   DROP TABLE public."отчеты";
       public         heap r       postgres    false            �            1259    16493    отчеты_отчет_id_seq    SEQUENCE     �   CREATE SEQUENCE public."отчеты_отчет_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public."отчеты_отчет_id_seq";
       public               postgres    false    232                       0    0    отчеты_отчет_id_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public."отчеты_отчет_id_seq" OWNED BY public."отчеты"."отчет_id";
          public               postgres    false    231            �            1259    16429    платежи    TABLE     C  CREATE TABLE public."платежи" (
    "платеж_id" integer NOT NULL,
    "бронирование_id" integer,
    "сумма" numeric(10,2) NOT NULL,
    "дата_платежа" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "способ_оплаты" character varying(50) NOT NULL,
    CONSTRAINT "платежи_способ_оплаты_check" CHECK ((("способ_оплаты")::text = ANY ((ARRAY['Карта'::character varying, 'Наличные'::character varying, 'Банковский перевод'::character varying])::text[])))
);
 $   DROP TABLE public."платежи";
       public         heap r       postgres    false            �            1259    16428 "   платежи_платеж_id_seq    SEQUENCE     �   CREATE SEQUENCE public."платежи_платеж_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE public."платежи_платеж_id_seq";
       public               postgres    false    224                       0    0 "   платежи_платеж_id_seq    SEQUENCE OWNED BY     o   ALTER SEQUENCE public."платежи_платеж_id_seq" OWNED BY public."платежи"."платеж_id";
          public               postgres    false    223            �            1259    16452    уборка    TABLE     �  CREATE TABLE public."уборка" (
    "уборка_id" integer NOT NULL,
    "номер_id" integer,
    "сотрудник_id" integer NOT NULL,
    "дата_уборки" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "статус" character varying(20) NOT NULL,
    CONSTRAINT "уборка_статус_check" CHECK ((("статус")::text = ANY ((ARRAY['Запланирвоно'::character varying, 'Выполнено'::character varying])::text[])))
);
 "   DROP TABLE public."уборка";
       public         heap r       postgres    false            �            1259    16451     уборка_уборка_id_seq    SEQUENCE     �   CREATE SEQUENCE public."уборка_уборка_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public."уборка_уборка_id_seq";
       public               postgres    false    226                       0    0     уборка_уборка_id_seq    SEQUENCE OWNED BY     k   ALTER SEQUENCE public."уборка_уборка_id_seq" OWNED BY public."уборка"."уборка_id";
          public               postgres    false    225            �            1259    16466    услуги    TABLE     �   CREATE TABLE public."услуги" (
    "услуга_id" integer NOT NULL,
    "название_услуги" character varying(100) NOT NULL,
    "описание" text,
    "цена" numeric(10,2) NOT NULL
);
 "   DROP TABLE public."услуги";
       public         heap r       postgres    false            �            1259    16476    услуги_гостей    TABLE     -  CREATE TABLE public."услуги_гостей" (
    "услуга_гость_id" integer NOT NULL,
    "гость_id" integer,
    "услуга_id" integer,
    "дата_использования" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "сумма" numeric(10,2) NOT NULL
);
 /   DROP TABLE public."услуги_гостей";
       public         heap r       postgres    false            �            1259    16475 8   услуги_гостей_услуга_гость_id_seq    SEQUENCE     �   CREATE SEQUENCE public."услуги_гостей_услуга_гость_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 Q   DROP SEQUENCE public."услуги_гостей_услуга_гость_id_seq";
       public               postgres    false    230                       0    0 8   услуги_гостей_услуга_гость_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public."услуги_гостей_услуга_гость_id_seq" OWNED BY public."услуги_гостей"."услуга_гость_id";
          public               postgres    false    229            �            1259    16465     услуги_услуга_id_seq    SEQUENCE     �   CREATE SEQUENCE public."услуги_услуга_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public."услуги_услуга_id_seq";
       public               postgres    false    228                       0    0     услуги_услуга_id_seq    SEQUENCE OWNED BY     k   ALTER SEQUENCE public."услуги_услуга_id_seq" OWNED BY public."услуги"."услуга_id";
          public               postgres    false    227            F           2604    16414 4   бронирования бронирование_id    DEFAULT     �   ALTER TABLE ONLY public."бронирования" ALTER COLUMN "бронирование_id" SET DEFAULT nextval('public."бронирования_бронирование_id_seq"'::regclass);
 g   ALTER TABLE public."бронирования" ALTER COLUMN "бронирование_id" DROP DEFAULT;
       public               postgres    false    222    221    222            E           2604    16405    гости гость_id    DEFAULT     �   ALTER TABLE ONLY public."гости" ALTER COLUMN "гость_id" SET DEFAULT nextval('public."гости_гость_id_seq"'::regclass);
 K   ALTER TABLE public."гости" ALTER COLUMN "гость_id" DROP DEFAULT;
       public               postgres    false    220    219    220            D           2604    16395    номера номер_id    DEFAULT     �   ALTER TABLE ONLY public."номера" ALTER COLUMN "номер_id" SET DEFAULT nextval('public."номера_номер_id_seq"'::regclass);
 M   ALTER TABLE public."номера" ALTER COLUMN "номер_id" DROP DEFAULT;
       public               postgres    false    217    218    218            N           2604    16497    отчеты отчет_id    DEFAULT     �   ALTER TABLE ONLY public."отчеты" ALTER COLUMN "отчет_id" SET DEFAULT nextval('public."отчеты_отчет_id_seq"'::regclass);
 M   ALTER TABLE public."отчеты" ALTER COLUMN "отчет_id" DROP DEFAULT;
       public               postgres    false    232    231    232            G           2604    16432    платежи платеж_id    DEFAULT     �   ALTER TABLE ONLY public."платежи" ALTER COLUMN "платеж_id" SET DEFAULT nextval('public."платежи_платеж_id_seq"'::regclass);
 Q   ALTER TABLE public."платежи" ALTER COLUMN "платеж_id" DROP DEFAULT;
       public               postgres    false    223    224    224            I           2604    16455    уборка уборка_id    DEFAULT     �   ALTER TABLE ONLY public."уборка" ALTER COLUMN "уборка_id" SET DEFAULT nextval('public."уборка_уборка_id_seq"'::regclass);
 O   ALTER TABLE public."уборка" ALTER COLUMN "уборка_id" DROP DEFAULT;
       public               postgres    false    225    226    226            K           2604    16469    услуги услуга_id    DEFAULT     �   ALTER TABLE ONLY public."услуги" ALTER COLUMN "услуга_id" SET DEFAULT nextval('public."услуги_услуга_id_seq"'::regclass);
 O   ALTER TABLE public."услуги" ALTER COLUMN "услуга_id" DROP DEFAULT;
       public               postgres    false    227    228    228            L           2604    16479 4   услуги_гостей услуга_гость_id    DEFAULT     �   ALTER TABLE ONLY public."услуги_гостей" ALTER COLUMN "услуга_гость_id" SET DEFAULT nextval('public."услуги_гостей_услуга_гость_id_seq"'::regclass);
 g   ALTER TABLE public."услуги_гостей" ALTER COLUMN "услуга_гость_id" DROP DEFAULT;
       public               postgres    false    229    230    230                      0    16411    бронирования 
   TABLE DATA           �   COPY public."бронирования" ("бронирование_id", "гость_id", "номер_id", "дата_заезда", "дата_выезда", "статус") FROM stdin;
    public               postgres    false    222   @f                 0    16402 
   гости 
   TABLE DATA           }   COPY public."гости" ("гость_id", "ФИО", "телефон", email, "паспортный_номер") FROM stdin;
    public               postgres    false    220   ]f                  0    16392    номера 
   TABLE DATA           z   COPY public."номера" ("номер_id", "номер", "тип_номера", "статус", "цена") FROM stdin;
    public               postgres    false    218   zf                 0    16494    отчеты 
   TABLE DATA           �   COPY public."отчеты" ("отчет_id", "тип_отчета", "дата_создания", "объект_id", "тип_объекта", "данные") FROM stdin;
    public               postgres    false    232   �f                 0    16429    платежи 
   TABLE DATA           �   COPY public."платежи" ("платеж_id", "бронирование_id", "сумма", "дата_платежа", "способ_оплаты") FROM stdin;
    public               postgres    false    224   �f                 0    16452    уборка 
   TABLE DATA           �   COPY public."уборка" ("уборка_id", "номер_id", "сотрудник_id", "дата_уборки", "статус") FROM stdin;
    public               postgres    false    226   �f       
          0    16466    услуги 
   TABLE DATA           |   COPY public."услуги" ("услуга_id", "название_услуги", "описание", "цена") FROM stdin;
    public               postgres    false    228   �f                 0    16476    услуги_гостей 
   TABLE DATA           �   COPY public."услуги_гостей" ("услуга_гость_id", "гость_id", "услуга_id", "дата_использования", "сумма") FROM stdin;
    public               postgres    false    230   g                  0    0 8   бронирования_бронирование_id_seq    SEQUENCE SET     i   SELECT pg_catalog.setval('public."бронирования_бронирование_id_seq"', 1, false);
          public               postgres    false    221                       0    0    гости_гость_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public."гости_гость_id_seq"', 1, false);
          public               postgres    false    219                       0    0    номера_номер_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public."номера_номер_id_seq"', 1, false);
          public               postgres    false    217                        0    0    отчеты_отчет_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public."отчеты_отчет_id_seq"', 1, false);
          public               postgres    false    231            !           0    0 "   платежи_платеж_id_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public."платежи_платеж_id_seq"', 1, false);
          public               postgres    false    223            "           0    0     уборка_уборка_id_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public."уборка_уборка_id_seq"', 1, false);
          public               postgres    false    225            #           0    0 8   услуги_гостей_услуга_гость_id_seq    SEQUENCE SET     i   SELECT pg_catalog.setval('public."услуги_гостей_услуга_гость_id_seq"', 1, false);
          public               postgres    false    229            $           0    0     услуги_услуга_id_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public."услуги_услуга_id_seq"', 1, false);
          public               postgres    false    227            ]           2606    16417 6   бронирования бронирования_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."бронирования"
    ADD CONSTRAINT "бронирования_pkey" PRIMARY KEY ("бронирование_id");
 d   ALTER TABLE ONLY public."бронирования" DROP CONSTRAINT "бронирования_pkey";
       public                 postgres    false    222            Y           2606    16407    гости гости_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public."гости"
    ADD CONSTRAINT "гости_pkey" PRIMARY KEY ("гость_id");
 H   ALTER TABLE ONLY public."гости" DROP CONSTRAINT "гости_pkey";
       public                 postgres    false    220            [           2606    16409 9   гости гости_паспортный_номер_key 
   CONSTRAINT     �   ALTER TABLE ONLY public."гости"
    ADD CONSTRAINT "гости_паспортный_номер_key" UNIQUE ("паспортный_номер");
 g   ALTER TABLE ONLY public."гости" DROP CONSTRAINT "гости_паспортный_номер_key";
       public                 postgres    false    220            U           2606    16398    номера номера_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public."номера"
    ADD CONSTRAINT "номера_pkey" PRIMARY KEY ("номер_id");
 L   ALTER TABLE ONLY public."номера" DROP CONSTRAINT "номера_pkey";
       public                 postgres    false    218            W           2606    16400 (   номера номера_номер_key 
   CONSTRAINT     o   ALTER TABLE ONLY public."номера"
    ADD CONSTRAINT "номера_номер_key" UNIQUE ("номер");
 V   ALTER TABLE ONLY public."номера" DROP CONSTRAINT "номера_номер_key";
       public                 postgres    false    218            g           2606    16502    отчеты отчеты_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public."отчеты"
    ADD CONSTRAINT "отчеты_pkey" PRIMARY KEY ("отчет_id");
 L   ALTER TABLE ONLY public."отчеты" DROP CONSTRAINT "отчеты_pkey";
       public                 postgres    false    232            _           2606    16436 "   платежи платежи_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public."платежи"
    ADD CONSTRAINT "платежи_pkey" PRIMARY KEY ("платеж_id");
 P   ALTER TABLE ONLY public."платежи" DROP CONSTRAINT "платежи_pkey";
       public                 postgres    false    224            a           2606    16459    уборка уборка_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public."уборка"
    ADD CONSTRAINT "уборка_pkey" PRIMARY KEY ("уборка_id");
 L   ALTER TABLE ONLY public."уборка" DROP CONSTRAINT "уборка_pkey";
       public                 postgres    false    226            c           2606    16473    услуги услуги_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public."услуги"
    ADD CONSTRAINT "услуги_pkey" PRIMARY KEY ("услуга_id");
 L   ALTER TABLE ONLY public."услуги" DROP CONSTRAINT "услуги_pkey";
       public                 postgres    false    228            e           2606    16482 8   услуги_гостей услуги_гостей_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."услуги_гостей"
    ADD CONSTRAINT "услуги_гостей_pkey" PRIMARY KEY ("услуга_гость_id");
 f   ALTER TABLE ONLY public."услуги_гостей" DROP CONSTRAINT "услуги_гостей_pkey";
       public                 postgres    false    230            h           2606    16418 D   бронирования бронирования_гость_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."бронирования"
    ADD CONSTRAINT "бронирования_гость_id_fkey" FOREIGN KEY ("гость_id") REFERENCES public."гости"("гость_id") ON DELETE CASCADE;
 r   ALTER TABLE ONLY public."бронирования" DROP CONSTRAINT "бронирования_гость_id_fkey";
       public               postgres    false    222    220    4697            i           2606    16423 D   бронирования бронирования_номер_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."бронирования"
    ADD CONSTRAINT "бронирования_номер_id_fkey" FOREIGN KEY ("номер_id") REFERENCES public."номера"("номер_id") ON DELETE CASCADE;
 r   ALTER TABLE ONLY public."бронирования" DROP CONSTRAINT "бронирования_номер_id_fkey";
       public               postgres    false    222    218    4693            j           2606    16437 >   платежи платежи_бронирование_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."платежи"
    ADD CONSTRAINT "платежи_бронирование_id_fkey" FOREIGN KEY ("бронирование_id") REFERENCES public."бронирования"("бронирование_id") ON DELETE CASCADE;
 l   ALTER TABLE ONLY public."платежи" DROP CONSTRAINT "платежи_бронирование_id_fkey";
       public               postgres    false    4701    222    224            k           2606    16460 ,   уборка уборка_номер_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."уборка"
    ADD CONSTRAINT "уборка_номер_id_fkey" FOREIGN KEY ("номер_id") REFERENCES public."номера"("номер_id") ON DELETE CASCADE;
 Z   ALTER TABLE ONLY public."уборка" DROP CONSTRAINT "уборка_номер_id_fkey";
       public               postgres    false    218    4693    226            l           2606    16483 F   услуги_гостей услуги_гостей_гость_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."услуги_гостей"
    ADD CONSTRAINT "услуги_гостей_гость_id_fkey" FOREIGN KEY ("гость_id") REFERENCES public."гости"("гость_id") ON DELETE CASCADE;
 t   ALTER TABLE ONLY public."услуги_гостей" DROP CONSTRAINT "услуги_гостей_гость_id_fkey";
       public               postgres    false    220    230    4697            m           2606    16488 H   услуги_гостей услуги_гостей_услуга_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."услуги_гостей"
    ADD CONSTRAINT "услуги_гостей_услуга_id_fkey" FOREIGN KEY ("услуга_id") REFERENCES public."услуги"("услуга_id") ON DELETE CASCADE;
 v   ALTER TABLE ONLY public."услуги_гостей" DROP CONSTRAINT "услуги_гостей_услуга_id_fkey";
       public               postgres    false    4707    230    228                  x������ � �            x������ � �             x������ � �            x������ � �            x������ � �            x������ � �      
      x������ � �            x������ � �     