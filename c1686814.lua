--アルティマヤ・ツィオルキン
function c1686814.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddGenericSpSummonProcedure(c,LOCATION_EXTRA,c1686814.sprfilter,c1686814.sprgoal,2,2,LOCATION_MZONE,0,nil,HINTMSG_TOGRAVE,Duel.SendtoGrave,HINTMSG_TOGRAVE)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SSET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c1686814.spcon)
	e3:SetTarget(c1686814.sptg)
	e3:SetOperation(c1686814.spop)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c1686814.tgcon)
	e4:SetValue(aux.imval1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function c1686814.sprfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(5) and c:IsAbleToGraveAsCost()
end
function c1686814.sprgoal(g,sync)
	return g:GetClassCount(Card.GetLevel)==1 and g:FilterCount(Card.IsType,nil,TYPE_TUNER)==1
end
function c1686814.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function c1686814.spfilter(c,e,tp)
	return (c:IsSetCard(0xc2) or (c:IsLevel(7,8) and c:IsRace(RACE_DRAGON)))
		and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c1686814.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1686814.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c1686814.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1686814.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c1686814.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c1686814.tgcon(e)
	return Duel.IsExistingMatchingCard(c1686814.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
