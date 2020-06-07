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
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c42166000.hspcon)
	e2:SetOperation(c42166000.hspop)
	c:RegisterEffect(e2)
	--triple tribute
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(42166000,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetCondition(c42166000.ttcon)
	e3:SetTarget(c42166000.tttg)
	e3:SetOperation(c42166000.ttop)
	e3:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e4)
	--battle indestructable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--cannot be target
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(c42166000.tgtg)
	e6:SetValue(aux.tgoval)
	c:RegisterEffect(e6)
	--atk limit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e7:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,LOCATION_MZONE)
	e7:SetValue(c42166000.tgtg)
	c:RegisterEffect(e7)
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
	return c:GetOriginalCode()==42166000 and c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0
end
function c42166000.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc<=3 and Duel.IsExistingMatchingCard(c42166000.ttfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c42166000.tttg(e,c)
	return c:IsCode(10000000,10000010,10000020,10000080,3912064,21208154,25524823,33022867,36354007,57793869,57761191,62180201,78651105)
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
