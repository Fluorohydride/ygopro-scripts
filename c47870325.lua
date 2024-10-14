--スマイル・アクション
---@param c Card
function c47870325.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c47870325.target)
	e1:SetOperation(c47870325.activate)
	c:RegisterEffect(e1)
	--disable attack
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c47870325.atktg)
	e2:SetOperation(c47870325.atkop)
	c:RegisterEffect(e2)
	local ng=Group.CreateGroup()
	ng:KeepAlive()
	e1:SetLabelObject(ng)
	e2:SetLabelObject(ng)
end
function c47870325.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_GRAVE)
end
function c47870325.rmfilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function c47870325.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c47870325.rmfilter),tp,LOCATION_GRAVE,0,nil,tp)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c47870325.rmfilter),tp,0,LOCATION_GRAVE,nil,1-tp)
	if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(47870325,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,5,nil)
		g:Merge(sg1)
	end
	if g2:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(47870325,0)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg2=g2:Select(1-tp,1,5,nil)
		g:Merge(sg2)
	end
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		if og:GetCount()==0 then return end
		local sg=e:GetLabelObject()
		if c:GetFlagEffect(47870325)==0 then
			sg:Clear()
			c:RegisterFlagEffect(47870325,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		local tc=og:GetFirst()
		while tc do
			if tc:IsLocation(LOCATION_REMOVED) then
				sg:AddCard(tc)
				tc:CreateRelation(c,RESET_EVENT+RESETS_STANDARD)
			end
			tc=og:GetNext()
		end
	else
		local sg=e:GetLabelObject()
		if sg:GetCount()>0 then
			sg:Clear()
		end
	end
end
function c47870325.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local p=1-ep
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,p,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,p,LOCATION_HAND)
end
function c47870325.thfilter(c,rc,p)
	return c:IsRelateToCard(rc) and c:IsControler(p) and c:IsAbleToHand()
end
function c47870325.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(47870325)==0 then return end
	local p=1-ep
	local g=e:GetLabelObject():Filter(c47870325.thfilter,nil,c,p)
	if g:GetCount()>0 and Duel.SelectYesNo(p,aux.Stringid(47870325,1)) then
		local res=false
		local sg=g:RandomSelect(1-p,1)
		local tc=sg:GetFirst()
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-p,tc)
			if tc:IsControler(p) and tc:IsDiscardable(REASON_EFFECT) and Duel.SelectYesNo(p,aux.Stringid(47870325,2)) then
				Duel.BreakEffect()
				if Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)~=0 then
					res=true
					Duel.NegateAttack()
				end
			end
		end
		if not res then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetValue(DOUBLE_DAMAGE)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,p)
		end
	end
end
