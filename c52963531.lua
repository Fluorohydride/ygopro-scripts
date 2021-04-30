--EMマンモスプラッシュ
function c52963531.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1)
	e2:SetCondition(c52963531.spcon)
	e2:SetTarget(c52963531.sptg)
	e2:SetOperation(c52963531.spop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=aux.AddFusionEffectProcUltimate(c,{
		filter=aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),
		mat_location=LOCATION_MZONE,
		reg=false
	})
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,52963531+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e3)
end
function c52963531.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsControler(tp)
end
function c52963531.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c52963531.cfilter,1,nil,tp)
end
function c52963531.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x99) and c:IsType(TYPE_PENDULUM)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c52963531.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c52963531.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c52963531.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c52963531.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
