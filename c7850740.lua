--エクシーズ・スライドルフィン
function c7850740.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7850740,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,7850740)
	e1:SetCondition(c7850740.spcon)
	e1:SetTarget(c7850740.sptg)
	e1:SetOperation(c7850740.spop)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7850740,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,7850741)
	e2:SetCondition(c7850740.matcon)
	e2:SetTarget(c7850740.mattg)
	e2:SetOperation(c7850740.matop)
	c:RegisterEffect(e2)
end
function c7850740.spfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c7850740.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c7850740.spfilter,1,nil,tp)
end
function c7850740.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c7850740.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c7850740.cfilter1(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsControler(tp) and c:IsCanBeEffectTarget(e)
end
function c7850740.matcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and eg:IsExists(c7850740.cfilter1,1,nil,e,tp)
end
function c7850740.tgfilter(c,tp,eg)
	return eg:IsContains(c) and c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsControler(tp)
end
function c7850740.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c7850740.tgfilter(chkc,tp,eg) end
	if chk==0 then return Duel.IsExistingTarget(c7850740.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp,eg) end
	if eg:GetCount()==1 then
		Duel.SetTargetCard(eg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c7850740.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,eg)
	end
end
function c7850740.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
