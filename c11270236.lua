--召喚獣エリュシオン
function c11270236.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xf4),c11270236.ffilter2,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c11270236.splimit)
	c:RegisterEffect(e1)
	--attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(0x2f)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11270236,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(c11270236.rmtg)
	e3:SetOperation(c11270236.rmop)
	c:RegisterEffect(e3)
end
function c11270236.ffilter2(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsLocation(LOCATION_MZONE)
end
function c11270236.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c11270236.rmfilter1(c,tp)
	local att=c:GetAttribute()
	return c:IsSetCard(0xf4) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c11270236.rmfilter2,tp,0,LOCATION_MZONE,1,nil,att)
end
function c11270236.rmfilter2(c,att)
	return c:IsFaceup() and c:IsAttribute(att) and c:IsAbleToRemove()
end
function c11270236.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(tp) and c11270236.rmfilter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c11270236.rmfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c11270236.rmfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
	local g2=Duel.GetMatchingGroup(c11270236.rmfilter2,tp,0,LOCATION_MZONE,nil,g1:GetFirst():GetAttribute())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,0)
end
function c11270236.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local tg=Group.FromCards(tc)
		if tc:IsFaceup() then
			local g=Duel.GetMatchingGroup(c11270236.rmfilter2,tp,0,LOCATION_MZONE,nil,tc:GetAttribute())
			tg:Merge(g)
		end
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end
