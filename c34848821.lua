--痕喰竜ブリガンド
function c34848821.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,68468459,aux.FilterBoolFunction(Card.IsLevelAbove,8),1,true,true)
	--indes battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c34848821.imcon)
	e2:SetTarget(c34848821.imval)
	e2:SetValue(c34848821.imfilter)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c34848821.regop)
	c:RegisterEffect(e3)
	--to hand/spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(34848821,0))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,34848821)
	e4:SetCondition(c34848821.thcon)
	e4:SetTarget(c34848821.thtg)
	e4:SetOperation(c34848821.thop)
	c:RegisterEffect(e4)
end
function c34848821.branded_fusion_check(tp,sg,fc)
	return aux.gffcheck(sg,Card.IsFusionCode,68468459,Card.IsLevelAbove,8)
end
function c34848821.imcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c34848821.imval(e,c)
	return c~=e:GetHandler()
end
function c34848821.imfilter(e,re,rp)
	return aux.tgoval(e,re,rp) and re:IsActiveType(TYPE_MONSTER)
end
function c34848821.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(34848821,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c34848821.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(34848821)>0
end
function c34848821.thfilter(c,e,tp)
	if not (c:IsSetCard(0x14d) and c:IsType(TYPE_MONSTER) or c:IsCode(68468459)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c34848821.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c34848821.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function c34848821.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c34848821.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
