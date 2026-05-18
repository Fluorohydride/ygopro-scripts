--捕食植物デェアデビル
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x10f3),aux.FilterBoolFunction(Card.IsLevel,1),true)
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.hspcon)
	e2:SetTarget(s.hsptg)
	e2:SetOperation(s.hspop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.descon)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
end
function s.hspfilter1(c,tp,fc,g)
	return c:IsFusionSetCard(0x10f3)
		and c:IsControler(tp) and c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL)
		and g:IsExists(s.hspfilter2,1,c,tp,fc)
end
function s.hspfilter2(c,tp,fc)
	return c:IsFaceup() and c:GetCounter(0x1041)>0
		and c:IsReleasable(REASON_MATERIAL|REASON_SPSUMMON)
		and c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL)
end
function s.hspfilter(c,tp,fc)
	return (c:IsFaceup() or c:IsControler(tp)) and (c:IsFusionSetCard(0x10f3) or c:GetCounter(0x1041)>0)
		and c:IsReleasable(REASON_MATERIAL|REASON_SPSUMMON)
		and c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL)
end
function s.fselect(g,tp,fc)
	return g:IsExists(s.hspfilter1,1,nil,tp,fc,g) and Duel.GetLocationCountFromEx(tp,tp,g,fc)>0
end
function s.hspcon(e,c)
	if c==nil then return true end
	local rg=Duel.GetMatchingGroup(s.hspfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandlerPlayer(),c)
	return rg:CheckSubGroup(s.fselect,2,2,e:GetHandlerPlayer(),c)
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetMatchingGroup(s.hspfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,s.fselect,true,2,2,tp,c)
	if sg and sg:GetCount()>0 then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SPSUMMON|REASON_MATERIAL)
	sg:DeleteGroup()
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN) and Duel.IsMainPhase()
end
function s.cfilter(c)
	return c:IsFaceup() and c:GetCounter(0x1041)>0
end
function s.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chkc then return chkc:IsOnField() and s.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and ct>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToChain,nil):Filter(Card.IsOnField,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
