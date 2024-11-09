--アルカナフォースⅩⅩⅠ－THE WORLD
---@param c Card
function c23846921.initial_effect(c)
	--coin
	aux.EnableArcanaCoin(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP_SUMMON_SUCCESS,EVENT_SPSUMMON_SUCCESS)
end
function c23846921.arcanareg(c,coin)
	--coin effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23846921,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c23846921.skipcon)
	e1:SetCost(c23846921.skipcost)
	e1:SetTarget(c23846921.skiptg)
	e1:SetOperation(c23846921.skipop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23846921,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_DRAW)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c23846921.thcon)
	e2:SetTarget(c23846921.thtg)
	e2:SetOperation(c23846921.thop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	c:RegisterFlagEffect(FLAG_ID_ARCANA_COIN,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end
function c23846921.skipcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and e:GetHandler():GetFlagEffectLabel(FLAG_ID_ARCANA_COIN)==1
end
function c23846921.skipcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c23846921.skiptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_TURN) end
end
function c23846921.skipop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function c23846921.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetFlagEffectLabel(FLAG_ID_ARCANA_COIN)==0
end
function c23846921.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=Duel.GetFieldCard(1-tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(1-tp,LOCATION_GRAVE,0)-1)
	if tc then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
	end
end
function c23846921.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(1-tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(1-tp,LOCATION_GRAVE,0)-1)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(tp,tc)
	end
end
