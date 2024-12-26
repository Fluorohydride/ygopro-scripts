--ルイ・キューピット
---@param c Card
function c21915012.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--lv up/down
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21915012,4))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c21915012.lvcon)
	e1:SetOperation(c21915012.lvop)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c21915012.valcheck)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c21915012.atkval)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21915012,0))
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,21915012)
	e3:SetCondition(c21915012.thcon)
	e3:SetTarget(c21915012.thtg)
	e3:SetOperation(c21915012.thop)
	c:RegisterEffect(e3)
	aux.CreateMaterialReasonCardRelation(c,e3)
end
function c21915012.matfilter(c)
	return c:IsType(TYPE_TUNER)
end
function c21915012.valcheck(e,c)
	local g=c:GetMaterial()
	local mg=g:Filter(Card.IsTuner,nil,c)
	local tc=mg:GetFirst()
	if not tc then
		e:GetLabelObject():SetLabel(0)
		return
	end
	if #mg>1 then
		local tg=g-(g:Filter(Card.IsNotTuner,nil,c))
		if #tg>0 then
			tc=tg:GetFirst()
		end
	end
	local lv=tc:GetSynchroLevel(c)
	local lv2=lv>>16
	lv=lv&0xffff
	if lv2>0 and not g:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),#g,#g,c) then
		lv=lv2
	end
	if tc:IsHasEffect(89818984) and not g:CheckWithSumEqual(Card.GetSynchroLevel,c:GetLevel(),#g,#g,c) then
		lv=2
	end
	e:GetLabelObject():SetLabel(lv)
end
function c21915012.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c21915012.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local ct=e:GetLabel()
	if ct==0 then return end
	local sel=nil
	if c:IsLevel(1) then
		sel=Duel.SelectOption(tp,aux.Stringid(21915012,1))
	else
		sel=Duel.SelectOption(tp,aux.Stringid(21915012,1),aux.Stringid(21915012,2))
	end
	if sel==1 then
		ct=ct*-1
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(ct)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end
function c21915012.atkval(e,c)
	return c:GetLevel()*400
end
function c21915012.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c21915012.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(8) and c:IsDefense(600) and c:IsAbleToHand()
end
function c21915012.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=e:GetHandler():GetReasonCard()
	local lv=rc:GetLevel()
	if chk==0 then return true end
	if rc:IsRelateToEffect(e) and rc:IsFaceup() then
		Duel.SetTargetCard(rc)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,lv*100)
	end
end
function c21915012.thop(e,tp,eg,ep,ev,re,r,rp)
	local rc=Duel.GetFirstTarget()
	if not rc or not rc:IsRelateToChain() or rc:IsFacedown() then return end
	local lv=rc:GetLevel()
	if Duel.Damage(1-tp,lv*100,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c21915012.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(21915012,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c21915012.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
	end
end
