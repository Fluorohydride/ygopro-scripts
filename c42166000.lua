--神・スライム
--not fully implemented
function c42166000.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_AQUA),c42166000.ffilter,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c42166000.splimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c42166000.hspcon)
	e2:SetOperation(c42166000.hspop)
	c:RegisterEffect(e2)
	--triple tribute(require 3 tributes, summon)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(42166000,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetCondition(c42166000.ttcon)
	e3:SetTarget(c42166000.tttg1)
	e3:SetOperation(c42166000.ttop)
	e3:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e3)
	--triple tribute(require 3 tributes, set)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_LIMIT_SET_PROC)
	e4:SetTarget(c42166000.tttg2)
	c:RegisterEffect(e4)
	--triple tribute(can tribute 3 monsters, summon)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_SUMMON_PROC)
	e5:SetTarget(c42166000.tttg3)
	e5:SetValue(SUMMON_TYPE_ADVANCE+SUMMON_VALUE_SELF)
	c:RegisterEffect(e5)
	--triple tribute(can tribute 3 monsters, set)
	--(reserved)
	--battle indestructable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--cannot be target
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetRange(LOCATION_MZONE)
	e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c42166000.tgtg)
	e8:SetValue(aux.tgoval)
	c:RegisterEffect(e8)
	--atk limit
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e9:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(0,LOCATION_MZONE)
	e9:SetValue(c42166000.tgtg)
	c:RegisterEffect(e9)
end
function c42166000.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_WATER) and c:IsLevel(10)
end
function c42166000.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c42166000.hspfilter(c,tp,sc)
	return c:IsAttack(0) and c:IsRace(RACE_AQUA) and c:IsLevel(10)
		and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function c42166000.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c42166000.hspfilter,1,nil,c:GetControler(),c)
end
function c42166000.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c42166000.hspfilter,1,1,nil,tp,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
function c42166000.ttfilter(c,tp)
	return c:IsCode(42166000) and c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0
end
function c42166000.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc<=3 and Duel.IsExistingMatchingCard(c42166000.ttfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c42166000.tttg1(e,c)
	return c:IsCode(10000000,10000010,10000020,10000080,21208154,57793869,57761191,62180201)
end
function c42166000.tttg2(e,c)
	return c:IsCode(21208154,57793869,62180201)
end
function c42166000.tttg3(e,c)
	return c:IsCode(3912064,25524823,36354007,75285069,78651105)
end
function c42166000.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c42166000.ttfilter,tp,LOCATION_MZONE,0,1,1,nil)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c42166000.tgtg(e,c)
	return not (c:IsCode(42166000) and c:IsFaceup())
end
