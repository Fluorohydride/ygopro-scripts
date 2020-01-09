--武神隠
function c11221418.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c11221418.target)
	e1:SetOperation(c11221418.activate)
	c:RegisterEffect(e1)
end
function c11221418.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x88) and c:IsType(TYPE_XYZ) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,0,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c11221418.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c11221418.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11221418.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c11221418.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,tg:GetCount(),0,0)
end
function c11221418.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		tc:RegisterFlagEffect(11221418,RESET_EVENT+RESETS_STANDARD,0,0)
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if g:GetCount()==0 then return end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		local rct=Duel.GetTurnCount(tp)+1
		if Duel.GetTurnPlayer()~=tp then rct=rct+1 end
		--cannot summon/flip summon/sp summon
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,1)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		Duel.RegisterEffect(e2,tp)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
		e3:SetLabelObject(e2)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e4:SetLabelObject(e3)
		Duel.RegisterEffect(e4,tp)
		--no damage
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_CHANGE_DAMAGE)
		e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e5:SetTargetRange(1,1)
		e5:SetValue(0)
		e5:SetLabelObject(e4)
		e5:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		Duel.RegisterEffect(e5,tp)
		local e6=e5:Clone()
		e6:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e6:SetLabelObject(e5)
		e6:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		Duel.RegisterEffect(e6,tp)
		--reset e2~e6
		local e7=Effect.CreateEffect(c)
		e7:SetDescription(aux.Stringid(11221418,0))
		e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e7:SetCode(EVENT_PHASE+PHASE_END)
		e7:SetCountLimit(1)
		e7:SetCondition(c11221418.resetcon)
		e7:SetOperation(c11221418.resetop)
		e7:SetLabel(rct)
		e7:SetLabelObject(e6)
		e7:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		Duel.RegisterEffect(e7,tp)
		--trigger effect
		local e8=Effect.CreateEffect(c)
		e8:SetDescription(aux.Stringid(11221418,1))
		e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e8:SetCode(EVENT_PHASE+PHASE_END)
		e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e8:SetCountLimit(1)
		e8:SetCondition(c11221418.spcon)
		e8:SetTarget(c11221418.sptg)
		e8:SetOperation(c11221418.spop)
		e8:SetLabel(rct)
		e8:SetLabelObject(tc)
		e8:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		Duel.RegisterEffect(e8,tp)
	end
end
function c11221418.resetcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetLabel()==Duel.GetTurnCount(tp)
end
function c11221418.resetop(e,tp,eg,ep,ev,re,r,rp)
	local e6=e:GetLabelObject()
	local e5=e6:GetLabelObject()
	local e4=e5:GetLabelObject()
	local e3=e4:GetLabelObject()
	local e2=e3:GetLabelObject()
	e2:Reset()
	e3:Reset()
	e4:Reset()
	e5:Reset()
	e6:Reset()
	e:Reset()
end
function c11221418.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetLabel()==Duel.GetTurnCount(tp)
end
function c11221418.mfilter(c)
	return c:IsSetCard(0x88) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function c11221418.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c11221418.mfilter(chkc) end
	if chk==0 then return true end
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,c11221418.mfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
end
function c11221418.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local mc=Duel.GetFirstTarget()
	if tc:GetFlagEffect(11221418)~=0 and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if mc and mc:IsRelateToEffect(e) then
			Duel.Overlay(tc,Group.FromCards(mc))
		end
	end
end
