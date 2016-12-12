--与奪の首飾り
function c48576971.initial_effect(c)
	aux.AddEquipProcedure(c)
	--effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(48576971,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c48576971.effcon)
	e3:SetTarget(c48576971.efftg)
	e3:SetOperation(c48576971.effop)
	c:RegisterEffect(e3)
end
function c48576971.effcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	return c:IsReason(REASON_LOST_TARGET) and ec:IsReason(REASON_BATTLE) and ec:GetPreviousControler()==tp
end
function c48576971.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local opt=0
	local b1=Duel.IsPlayerCanDraw(tp,1)
	local b2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(48576971,1),aux.Stringid(48576971,2))
	elseif b1 then
		opt=Duel.SelectOption(tp,aux.Stringid(48576971,1))
	elseif b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(48576971,2))+1
	else opt=2 end
	e:SetLabel(opt)
	if opt==0 then
		e:SetCategory(CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	elseif opt==1 then
		e:SetCategory(CATEGORY_HANDES)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
	else
		e:SetCategory(0)
		e:SetProperty(0)
	end
end
function c48576971.effop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	elseif e:GetLabel()==1 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		local g=Duel.GetFieldGroup(p,LOCATION_HAND,0):RandomSelect(p,d)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	end
end
