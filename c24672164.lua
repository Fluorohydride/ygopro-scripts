--幻奏の華歌聖ブルーム・プリマ
function c24672164.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c24672164.fscon)
	e1:SetOperation(c24672164.fsop)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c24672164.matcheck)
	c:RegisterEffect(e2)
	--Double attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--To hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(24672164,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(c24672164.thcon)
	e4:SetTarget(c24672164.thtg)
	e4:SetOperation(c24672164.thop)
	c:RegisterEffect(e4)
end
function c24672164.fscon(e,g,gc,chkf)
	if g==nil then
		return false
	end
	if gc then
		local g1=g:Filter(Card.IsFusionSetCard,nil,0x9b)
		if not g1:IsContains(gc) then g1:AddCard(gc) end
		local ct1=g1:GetCount()
		local ct2=g1:FilterCount(Card.IsFusionSetCard,nil,0x109b)
		return gc:IsSetCard(0x9b) and ct1>=2 and ct2>0
	end
	local g1=g:Filter(Card.IsFusionSetCard,nil,0x9b)
	local ct1=g1:GetCount()
	local ct2=g1:FilterCount(Card.IsFusionSetCard,nil,0x109b)
	if chkf~=PLAYER_NONE and not g1:IsExists(aux.FConditionCheckF,1,nil,chkf) then return false end
	return ct1>=2 and ct2>0
end
function c24672164.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	if gc then
		local g1=eg:Filter(Card.IsFusionSetCard,nil,0x9b)
		local mg=Group.CreateGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local tc=g1:FilterSelect(tp,Card.IsFusionSetCard,1,1,nil,0x109b):GetFirst()
		mg:AddCard(tc)
		if g1:IsContains(tc) then g1:RemoveCard(tc) end
		mg:AddCard(gc)
		if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(24672164,1)) then
			local fg2=g1:Select(tp,1,63,tc)
			mg:Merge(fg2)
		end
		Duel.SetFusionMaterial(mg)
		return
	end
	local g1=eg:Filter(Card.IsFusionSetCard,nil,0x9b)
	local mg=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local tc=g1:FilterSelect(tp,Card.IsFusionSetCard,1,1,nil,0x109b):GetFirst()
	mg:AddCard(tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local fg2=g1:Select(tp,1,63,tc)
	mg:Merge(fg2)
	Duel.SetFusionMaterial(mg)
end
function c24672164.matcheck(e,c)
	local ct=c:GetMaterialCount()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(ct*300)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c24672164.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c24672164.filter(c)
	return c:IsSetCard(0x9b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c24672164.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c24672164.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c24672164.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c24672164.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c24672164.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
