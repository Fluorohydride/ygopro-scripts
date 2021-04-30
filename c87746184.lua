--烙印竜アルビオン
function c87746184.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,68468459,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_LIGHT),1,true,true)
	--fusion summon
	local e1=aux.AddFusionEffectProcUltimate(c,{
		filter=c87746184.ffilter,
		mat_location=LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,
		mat_filter=Card.IsAbleToRemove,
		mat_operation=aux.FMaterialRemove,
		reg=false
	})
	e1:SetDescription(aux.Stringid(87746184,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,87746184)
	e1:SetCondition(c87746184.condition)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c87746184.regop)
	c:RegisterEffect(e2)
	--to hand/set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(87746184,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,87746185)
	e3:SetCondition(c87746184.thcon)
	e3:SetTarget(c87746184.thtg)
	e3:SetOperation(c87746184.thop)
	c:RegisterEffect(e3)
end
function c87746184.ffilter(c)
	return c:IsLevelBelow(8) and not c:IsCode(87746184)
end
function c87746184.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and Duel.GetCurrentPhase()&(PHASE_DAMAGE+PHASE_DAMAGE_CAL)==0
end
function c87746184.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(87746184,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c87746184.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(87746184)>0
end
function c87746184.thfilter(c)
	if not (c:IsSetCard(0x15d) and c:IsType(TYPE_SPELL+TYPE_TRAP)) then return false end
	return c:IsAbleToHand() or c:IsSSetable()
end
function c87746184.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c87746184.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c87746184.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c87746184.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
		end
	end
end
